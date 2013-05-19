class Unsubscribe
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]
  end

  def execute
    if @relay.subscribed?(@sender)
      subscription = @relay.subscription_for(@sender)
      subscription.destroy

      SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.goodbye'))

      TxtsRelayAdmins.txt_relay_admins(relay: @relay, body: I18n.t('txts.admin.unsubscribed', number: @sender.number, name: @sender.name_or_anon))
    else
      SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.not_subscribed'))
    end
  end
end
