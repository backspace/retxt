class Unvoice
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]

    @arguments = options[:arguments]
    @finds_subscribers = options[:finds_subscribers] || FindsSubscribers
  end

  def execute
    if @sender.admin
      unvoicee = @finds_subscribers.find(@arguments)

      if unvoicee
        subscription = @relay.subscription_for(unvoicee)

        if subscription
          subscription.unvoice!
          SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.unvoice', unvoicee_name: @arguments))
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
