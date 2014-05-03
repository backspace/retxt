class Unadmin
  def initialize(command_context)
    @sender = command_context.sender
    @relay = command_context.relay

    @arguments = command_context.arguments
  end

  def execute
    if @sender.admin
      unadminee = FindsSubscribers.find(@arguments)

      if unadminee
        unadminee.unadmin!

        TxtsRelayAdmins.txt_relay_admins(relay: @relay, body: I18n.t('txts.admin.unadmin', unadminer_name: @sender.addressable_name, unadminee_name: unadminee.addressable_name))
      else
        SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.missing_target', target: @arguments))
      end
    else
      SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.nonadmin'))
    end
  end
end
