class Open
  def initialize(command_context)
    @command_context = command_context
    @sender = command_context.sender
    @relay = command_context.relay
  end

  def execute
    ModifyRelay.new(@command_context, modifier: :open, success_response: RelayModificationNotification.new(@command_context, 'open')).execute
  end
end
