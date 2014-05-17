require_relative 'abstract_command'

class Admin < AbstractCommand
  def execute
    if sender.admin
      adminee = FindsSubscribers.find(arguments)

      if adminee
        adminee.admin!

        AdminificationNotification.new(context).deliver(relay.admins)
      else
        MissingTargetBounceResponse.new(context).deliver(sender)
      end
    else
      NonAdminBounceResponse.new(context).deliver(sender)
      NonAdminBounceNotification.new(context).deliver relay.admins
    end
  end
end
