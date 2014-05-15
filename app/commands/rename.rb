class Rename
  def initialize(command_context)
    @command_context = command_context
    @sender = command_context.sender
    @relay = command_context.relay

    @arguments = command_context.arguments
  end

  def execute
    if @sender.admin
      @relay.rename(@arguments)
      RenameResponse.new(@command_context).deliver @sender
    else
      NonAdminBounceResponse.new(@command_context).deliver @sender
    end
  end
end
