class Clear
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]
  end

  def execute
    if @sender.admin
      @relay.non_admins.each do |subscriber|
        @relay.subscription_for(subscriber).destroy
      end

      TxtsRelayAdmins.txt_relay_admins(relay: @relay, body: I18n.t('txts.admin.clear'))
    else
      SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.nonadmin'))
    end
  end
end
