class Moderate
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]
  end

  def execute
    ModifyRelay.new(sender: @sender, relay: @relay, modifier: :moderate!, success_message: I18n.t('txts.admin.moderate')).execute
  end
end
