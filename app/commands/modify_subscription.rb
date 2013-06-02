class ModifySubscription
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]
    @arguments = options[:arguments]

    @modifier = options[:modifier]
    @success_message = options[:success_message]
  end

  def execute
    if @sender.admin
      target = FindsSubscribers.find(@arguments)

      if target
        subscription = @relay.subscription_for(target)

        if subscription
          @modifier.call(subscription)
          TxtsRelayAdmins.txt_relay_admins(relay: @relay, body: @success_message)
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
