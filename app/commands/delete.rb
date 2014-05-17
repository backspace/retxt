require_relative 'abstract_command'

class Delete < AbstractCommand
  def execute
    if sender.admin
      DeletionNotification.new(context).deliver(relay.admins)
      DeletesRelays.delete_relay(relay: relay)
    else
      NonAdminBounceResponse.new(context).deliver sender
      NonAdminBounceNotification.new(context).deliver relay.admins
    end
  end
end
