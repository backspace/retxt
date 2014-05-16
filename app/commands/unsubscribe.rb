class Unsubscribe
  def initialize(command_context)
    @command_context = command_context
    @sender = command_context.sender
    @relay = command_context.relay
  end

  def execute
    if @relay.subscribed?(@sender)
      subscription = @relay.subscription_for(@sender)
      subscription.destroy

      UnsubscribeResponse.new(@command_context).deliver @sender
      UnsubscriptionNotification.new(@command_context).deliver @relay.admins
    else
      NotSubscribedBounceResponse.new(@command_context).deliver @sender
      NotSubscribedUnsubscribeBounceNotification.new(@command_context).deliver @relay.admins
    end
  end
end
