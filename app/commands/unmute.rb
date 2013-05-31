class Unmute
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]

    @arguments = options[:arguments]
    @finds_subscribers = options[:finds_subscribers] || FindsSubscribers
  end

  def execute
    if @sender.admin
      unmutee = @finds_subscribers.find(@arguments)

      if unmutee
        subscription = @relay.subscription_for(unmutee)

        if subscription
          subscription.unmute!
          SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.unmute', unmutee_name: @arguments))
        else
          SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.unsubscribed_target', target: @arguments))
        end
      else
        SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.missing_target', target: @arguments))
      end
    else
      SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.nonadmin'))
    end
  end
end
