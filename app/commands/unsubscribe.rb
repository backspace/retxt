require_relative 'abstract_command'

class Unsubscribe < AbstractCommand
  def execute
    if relay.subscribed?(sender)
      subscription = relay.subscription_for(sender)
      subscription.destroy

      UnsubscribeResponse.new(context).deliver sender
      UnsubscriptionNotification.new(context).deliver relay.admins
    else
      NotSubscribedBounceResponse.new(context).deliver sender
      NotSubscribedUnsubscribeBounceNotification.new(context).deliver relay.admins
    end
  end
end
