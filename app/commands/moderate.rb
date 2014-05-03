class Moderate
  def initialize(command_context)
    @command_context = command_context
    @sender = command_context.sender
    @relay = command_context.relay
  end

  def execute
    ModifyRelay.new(@command_context, modifier: :moderate!, success_message: I18n.t('txts.admin.moderate', admin_name: @sender.addressable_name)).execute
  end
end
