class Unknown
  def initialize(command_context)
    @sender = command_context.sender
    @relay = command_context.relay

    @arguments = command_context.arguments
  end

  def execute
    SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.unknown'))
  end
end
