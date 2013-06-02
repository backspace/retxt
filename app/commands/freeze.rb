class Freeze
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]
  end

  def execute
    ModifyRelay.new(sender: @sender, relay: @relay, modifier: :freeze!, success_message: I18n.t('txts.freeze', admin_name: @sender.addressable_name)).execute
  end
end
