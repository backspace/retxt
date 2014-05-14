class Timestamp
  def initialize(command_context)
    @command_context = command_context
    @sender = command_context.sender
    @arguments = command_context.arguments
  end

  def execute
    ModifyRelay.new(@command_context, modifier: :timestamp!, success_response: TimestampModificationNotification.new(@command_context)).execute
  end
end
