class Who
  def initialize(command_context, options = {})
    @sender = command_context.sender
    @relay = command_context.relay

    @who_txt = options[:who_txt] || WhoResponse
  end

  def execute
    if @sender.admin
      txt = @who_txt.generate(relay: @relay)

      SendsTxts.send_txts(from: @relay.number, to: @sender.number, body: txt)
    else
      SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.nonadmin'))
    end
  end
end
