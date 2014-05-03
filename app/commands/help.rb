class Help
  def initialize(command_context)
    @sender = command_context.sender
    @relay = command_context.relay

    @arguments = command_context.arguments
  end

  def execute
    SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.help', subscriber_count: I18n.t('subscribers', count: @relay.subscribers.length - 1)))
  end
end
