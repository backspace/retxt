class Unmute
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]

    @arguments = options[:arguments]
  end

  def execute
    ModifySubscription.new(sender: @sender, relay: @relay, arguments: @arguments, success_message: I18n.t('txts.unmute', unmutee_name: @arguments, admin_name: @sender.addressable_name), modifier: modifier).execute
  end

  private
  def modifier
    lambda do |subscription|
      subscription.unmute!
    end
  end
end
