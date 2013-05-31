class Thaw
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]
  end

  def execute
    ModifyRelay.new(sender: @sender, relay: @relay, i18n: I18n, sends_txts: @sends_txts, modifier: :thaw!, success_message: I18n.t('txts.thaw')).execute
  end
end
