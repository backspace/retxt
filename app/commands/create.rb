class Create
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]

    @i18n = options[:i18n] || I18n
    @sends_txts = options[:sends_txts] || SendsTxts

    @application_url = options[:application_url]

    @arguments = options[:arguments]
  end

  def execute
    if @sender.admin
      new_relay_number = BuysNumbers.buy_number('514', @application_url)
      relay = Relay.create(name: @arguments, number: new_relay_number)
      Subscription.create(relay: relay, subscriber: @sender)

      TxtsRelayAdmins.txt_relay_admins(relay: relay, body: @i18n.t('txts.admin.create', admin_name: @sender.addressable_name, relay_name: relay.name))
    else
      @sends_txts.send_txt(from: @relay.number, to: @sender.number, body: @i18n.t('txts.nonadmin'))
    end
  end
end
