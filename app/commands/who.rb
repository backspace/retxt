class Who
  def initialize(command_context, options = {})
    @command_context = command_context
    @sender = command_context.sender
    @relay = command_context.relay

    @who_txt = options[:who_txt] || WhoResponse
  end

  def execute
    if @sender.admin
      txt = @who_txt.generate(relay: @relay)

      SendsTxts.send_txts(from: @relay.number, to: @sender.number, body: txt, originating_txt_id: @command_context.originating_txt_id)
    else
      SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.nonadmin'), originating_txt_id: @command_context.originating_txt_id)
    end
  end
end
