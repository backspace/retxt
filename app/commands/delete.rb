class Delete
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]
  end

  def execute
    if @sender.admin
      TxtsRelayAdmins.txt_relay_admins(relay: @relay, body: I18n.t('txts.admin.delete', admin_name: @sender.addressable_name))
      DeletesRelays.delete_relay(relay: @relay)
    else
      SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.nonadmin'))
    end
  end
end
