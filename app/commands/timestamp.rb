class Timestamp
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]
    @arguments = options[:arguments]
  end

  def execute
    ModifyRelay.new(sender: @sender, relay: @relay, modifier: :timestamp!, arguments: @arguments, success_message: I18n.t('txts.admin.timestamp', admin_name: @sender.addressable_name, timestamp: @arguments)).execute
  end
end
