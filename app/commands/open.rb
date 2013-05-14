class Open
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]

    @i18n = options[:i18n] || I18n
    @sends_txts = options[:sends_txts] || SendsTxts
  end

  def execute
    ModifyRelay.new(sender: @sender, relay: @relay, i18n: @i18n, sends_txts: @sends_txts, modifier: :open!, success_message: @i18n.t('txts.open')).execute
  end
end
