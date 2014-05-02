class ModifyRelay
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]

    @modifier = options[:modifier]
    @arguments = options[:arguments]
    @success_message = options[:success_message]
  end

  def execute
    if @sender.admin
      if @arguments
        @relay.send(@modifier, @arguments)
      else
        @relay.send(@modifier)
      end
      TxtsRelayAdmins.txt_relay_admins(relay: @relay, body: @success_message)
    else
      SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.nonadmin'))
    end
  end
end
