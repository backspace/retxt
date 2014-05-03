class Admin
  def initialize(command_context)
    @command_context = command_context
    @sender = command_context.sender
    @relay = command_context.relay

    @arguments = command_context.arguments
  end

  def execute
    if @sender.admin
      adminee = FindsSubscribers.find(@arguments)

      if adminee
        adminee.admin!

        TxtsRelayAdmins.txt_relay_admins(relay: @relay, body: I18n.t('txts.admin.admin', adminer_name: @sender.addressable_name, adminee_name: adminee.addressable_name), originating_txt_id: @command_context.originating_txt_id)
      else
        SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.missing_target', target: @arguments), originating_txt_id: @command_context.originating_txt_id)
      end
    else
      SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.nonadmin'), originating_txt_id: @command_context.originating_txt_id)
    end
  end
end
