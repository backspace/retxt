require_relative 'abstract_command'

class Unadmin < AbstractCommand
  def execute
    if sender.admin
      unadminee = FindsSubscribers.find(arguments)

      if unadminee
        unadminee.unadmin!
        UnadminificationNotification.new(context).deliver(relay.admins)
      else
        MissingTargetBounceResponse.new(context).deliver(sender)
      end
    else
      NonAdminBounceResponse.new(context).deliver(sender)
      NonAdminBounceNotification.new(context).deliver relay.admins
    end
  end
end
