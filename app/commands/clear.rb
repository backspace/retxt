require_relative 'abstract_command'

class Clear < AbstractCommand
  def execute
    if sender.admin
      relay.non_admins.each do |subscriber|
        relay.subscription_for(subscriber).destroy
      end

      ClearNotification.new(context).deliver(relay.admins)
    else
      NonAdminBounceResponse.new(context).deliver(sender)
      NonAdminBounceNotification.new(context).deliver relay.admins
    end
  end
end
