class ModifyRelay
  def initialize(command_context, options)
    @command_context = command_context
    @sender = command_context.sender
    @relay = command_context.relay

    @modifier = options[:modifier]
    @arguments = command_context.arguments
    @success_message = options[:success_message]
  end

  def execute
    if @sender.admin
      if @arguments
        @relay.send(@modifier, @arguments)
      else
        @relay.send(@modifier)
      end
      TxtsRelayAdmins.txt_relay_admins(relay: @relay, body: @success_message, originating_txt_id: @command_context.originating_txt_id)
    else
      SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.nonadmin'), originating_txt_id: @command_context.originating_txt_id)
    end
  end
end
