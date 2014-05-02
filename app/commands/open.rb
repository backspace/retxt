class Open
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]
  end

  def execute
    ModifyRelay.new(sender: @sender, relay: @relay, modifier: :open!, success_message: I18n.t('txts.admin.open', admin_name: @sender.addressable_name)).execute
  end
end
