require_relative 'abstract_command'

class Create < AbstractCommand
  def execute
    if sender.admin
      new_relay_number = similar_number_buyer.buy_similar_number
      new_relay = Relay.create(name: arguments, number: new_relay_number)
      Subscription.create(relay: new_relay, subscriber: sender)

      CreationNotification.new(context).deliver(new_relay.admins)
    else
      NonAdminBounceResponse.new(context).deliver(sender)
      NonAdminBounceNotification.new(context).deliver relay.admins
    end
  end

  private
  def similar_number_buyer
    if area_code
      BuysSimilarNumbers.new(relay.number, application_url, area_code)
    else
      BuysSimilarNumbers.new(relay.number, application_url)
    end
  end

  def name
    arguments.split.first
  end

  def area_code
    arguments.split[1]
  end
end
