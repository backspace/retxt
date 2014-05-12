class Unmoderate
  def initialize(command_context)
    @command_context = command_context
    @sender = command_context.sender
    @relay = command_context.relay
  end

  def execute
    ModifyRelay.new(@command_context, modifier: :unmoderate, success_message: I18n.t('txts.admin.unmoderate', admin_name: @sender.addressable_name)).execute
  end
end
