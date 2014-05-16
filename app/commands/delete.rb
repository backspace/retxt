class Delete
  def initialize(command_context)
    @command_context = command_context
    @sender = command_context.sender
    @relay = command_context.relay
  end

  def execute
    if @sender.admin
      DeletionNotification.new(@command_context).deliver(@relay.admins)
      DeletesRelays.delete_relay(relay: @relay)
    else
      NonAdminBounceResponse.new(@command_context).deliver @sender
      NonAdminBounceNotification.new(@command_context).deliver @relay.admins
    end
  end
end
