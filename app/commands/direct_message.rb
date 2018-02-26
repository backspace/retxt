require_relative 'abstract_command'

class DirectMessage < AbstractCommand
  def execute
    if relay.subscribed?(sender)
      if sender.anonymous?
        ForbiddenAnonymousDirectMessageBounceResponse.new(context).deliver sender
      else
        target_subscriber = FindsSubscribers.find(target)

        if target_subscriber
          OutgoingDirectMessageResponse.new(context).deliver(target_subscriber)
          OutgoingDirectMessageCopyNotification.new(context).deliver(relay.admins)
          SentDirectMessageResponse.new(context).deliver(sender)
        else
          meeting_group_name = target[1..-1]
          meeting = Meeting.where(code: meeting_group_name).first

          if meeting
            @context.meeting = meeting
            OutgoingGroupMessageResponse.new(context).deliver(meeting.subscribers - [sender] + relay.admins)
            SentGroupMessageResponse.new(context).deliver(sender)
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
