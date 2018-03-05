require_relative 'abstract_command'

class DirectMessage < AbstractCommand
  def execute
    if relay.subscribed?(sender)
      if sender.anonymous?
        ForbiddenAnonymousDirectMessageBounceResponse.new(context).deliver sender
      else
        target_subscriber = FindsSubscribers.find(target)
        team = Team.where(name: target.downcase[1..-1]).first

        if target_subscriber
          OutgoingDirectMessageResponse.new(context).deliver(target_subscriber)
          OutgoingDirectMessageCopyNotification.new(context).deliver(relay.admins)
          SentDirectMessageResponse.new(context).deliver(sender)
        elsif team
          OutgoingDirectMessageCopyNotification.new(context).deliver(relay.admins)

          team.subscribers.each do |target_subscriber|
            OutgoingDirectMessageResponse.new(context).deliver(target_subscriber)
            SentDirectMessageResponse.new(context).deliver(sender)
          end
        else
          meeting_group_name = target[1..-1]
          meeting = Meeting.where(code: meeting_group_name).first

          if meeting
            @context.meeting = meeting
            if meeting.messaged
              recipients = meeting.teams.map(&:subscribers) - [sender] + relay.admins
              OutgoingGroupMessageResponse.new(context).deliver(recipients)
              SentGroupMessageResponse.new(context).deliver(sender)
            else
              PrematureGroupMessageResponse.new(context).deliver(sender)
              PrematureGroupMessageAdminNotification.new(context).deliver(relay.admins)
            end
          else
            MissingDirectMessageTargetBounceResponse.new(context).deliver(sender)
          end
        end
      end
    end
  end

  private
  def target
    context.txt.body.split.first
  end
end
