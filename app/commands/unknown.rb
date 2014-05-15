class Unknown
  def initialize(command_context)
    @command_context = command_context
    @sender = command_context.sender
    @relay = command_context.relay

    @arguments = command_context.arguments
  end

  def execute
    UnknownBounceResponse.new(@command_context).deliver @sender
  end
end
