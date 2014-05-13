class Help
  def initialize(command_context)
    @command_context = command_context
    @sender = command_context.sender
    @relay = command_context.relay

    @arguments = command_context.arguments
  end

  def execute
    HelpResponse.new(@command_context).deliver @sender
  end
end
