class Unmoderate
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]
  end

  def execute
    ModifyRelay.new(sender: @sender, relay: @relay, modifier: :unmoderate!, success_message: I18n.t('txts.admin.unmoderate', admin_name: @sender.addressable_name)).execute
  end
end
