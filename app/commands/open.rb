class Open
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]
  end

  def execute
    ModifyRelay.new(sender: @sender, relay: @relay, i18n: I18n, sends_txts: @sends_txts, modifier: :open!, success_message: I18n.t('txts.open')).execute
  end
end
