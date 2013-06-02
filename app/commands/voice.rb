class Voice
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]

    @arguments = options[:arguments]
  end

  def execute
    ModifySubscription.new(sender: @sender, relay: @relay, arguments: @arguments, success_message: I18n.t('txts.voice', voicee_name: @arguments), modifier: modifier).execute
  end

  private
  def modifier
    lambda do |subscription|
      subscription.voice!
    end
  end
end
