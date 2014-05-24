require_relative 'abstract_command'

class Create < AbstractCommand
  def execute
    if sender.admin
      new_relay_number = BuysSimilarNumbers.new(relay.number, application_url).buy_similar_number
      new_relay = Relay.create(name: arguments, number: new_relay_number)
      Subscription.create(relay: new_relay, subscriber: sender)

      CreationNotification.new(context).deliver(new_relay.admins)
    else
      NonAdminBounceResponse.new(context).deliver(sender)
      NonAdminBounceNotification.new(context).deliver relay.admins
    end
  end
end
