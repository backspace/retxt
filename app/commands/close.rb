class Close
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]
  end

  def execute
    ModifyRelay.new(sender: @sender, relay: @relay, modifier: :close!, success_message: I18n.t('txts.admin.close', admin_name: @sender.addressable_name)).execute
  end
end
