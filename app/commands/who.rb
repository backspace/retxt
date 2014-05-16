class Who
  def initialize(command_context)
    @command_context = command_context
    @sender = command_context.sender
    @relay = command_context.relay
  end

  def execute
    if @sender.admin
      WhoResponse.new(@command_context).deliver @sender
    else
      NonAdminBounceResponse.new(@command_context).deliver @sender
      NonAdminBounceNotification.new(@command_context).deliver @relay.admins
    end
  end
end
