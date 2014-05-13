class DirectMessage
  def initialize(command_context)
    @command_context = command_context
    @sender = command_context.sender
    @relay = command_context.relay

    @txt = command_context.txt
    @content = @txt.body
  end

  def execute
    if @relay.subscribed?(@sender)
      if @sender.anonymous?
        ForbiddenAnonymousDirectMessageResponse.new(@command_context).deliver @sender
      else
        target_subscriber = FindsSubscribers.find(target)

        if target_subscriber
          OutgoingDirectMessageResponse.new(@command_context).deliver(target_subscriber)
          SentDirectMessageResponse.new(@command_context).deliver(@sender)
        else
          MissingDirectMessageTargetResponse.new(@command_context).deliver(@sender)
        end
      end
    end
  end

  private
  def target
    @content.split.first
  end
end
