class Thaw
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]
  end

  def execute
    ModifyRelay.new(sender: @sender, relay: @relay, modifier: :thaw!, success_message: I18n.t('txts.thaw')).execute
  end
end
