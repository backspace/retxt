class Unsubscribe
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]
    @i18n = options[:i18n] || I18n
    @sends_txts = options[:sends_txts] || SendsTxts
  end

  def execute
    if @relay.subscribed?(@sender)
      subscription = @relay.subscription_for(@sender)
      subscription.destroy

      @sends_txts.send_txt(from: @relay.number, to: @sender.number, body: @i18n.t('txts.goodbye'))

      TxtsRelayAdmins.txt_relay_admins(relay: @relay, body: @i18n.t('txts.admin.unsubscribed', number: @sender.number, name: @sender.name_or_anon))
    else
      @sends_txts.send_txt(from: @relay.number, to: @sender.number, body: @i18n.t('txts.not_subscribed'))
    end
  end
end
