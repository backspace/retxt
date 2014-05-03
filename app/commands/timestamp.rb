class Timestamp
  def initialize(command_context)
    @command_context = command_context
    @sender = command_context.sender
    @arguments = command_context.arguments
  end

  def execute
    ModifyRelay.new(@command_context, modifier: :timestamp!, success_message: I18n.t('txts.admin.timestamp', admin_name: @sender.addressable_name, timestamp: @arguments)).execute
  end
end
