class Delete
  def initialize(command_context)
    @command_context = command_context
    @sender = command_context.sender
    @relay = command_context.relay
  end

  def execute
    if @sender.admin
      TxtsRelayAdmins.txt_relay_admins(relay: @relay, body: I18n.t('txts.admin.delete', admin_name: @sender.addressable_name))
      DeletesRelays.delete_relay(relay: @relay)
    else
      SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.nonadmin'), originating_txt_id: @command_context.originating_txt_id)
    end
  end
end
