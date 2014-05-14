class Freeze
  def initialize(command_context)
    @command_context = command_context
    @sender = command_context.sender
    @relay = command_context.relay
  end

  def execute
    ModifyRelay.new(@command_context, modifier: :freeze, success_response: RelayModificationNotification.new(@command_context, 'freeze')).execute
  end
end
