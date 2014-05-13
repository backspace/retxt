class Name
  def initialize(command_context)
    @command_context = command_context
    @sender = command_context.sender
    @relay = command_context.relay

    @new_name = command_context.arguments
  end

  def execute
    ChangesNames.change_name(@sender, @new_name)
    NameResponse.new(@command_context).deliver @sender
  end
end
