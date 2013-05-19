class Clear
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]

    @i18n = options[:i18n] || I18n
    @sends_txts = options[:sends_txts] || SendsTxts
  end

  def execute
    if @sender.admin
      @relay.non_admins.each do |subscriber|
        @relay.subscription_for(subscriber).destroy
      end

      TxtsRelayAdmins.txt_relay_admins(relay: @relay, body: @i18n.t('txts.admin.clear'))
    else
      @sends_txts.send_txt(from: @relay.number, to: @sender.number, body: @i18n.t('txts.nonadmin'))
    end
  end
end
