class ModifyRelay
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]

    @modifier = options[:modifier]
    @success_message = options[:success_message]
  end

  def execute
    if @sender.admin
      @relay.send(@modifier)
      TxtsRelayAdmins.txt_relay_admins(relay: @relay, body: @success_message)
    else
      SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.nonadmin'))
    end
  end
end
