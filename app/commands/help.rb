class Help
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]

    @arguments = options[:arguments]
  end

  def execute
    SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.help', subscriber_count: I18n.t('subscribers', count: @relay.subscribers.length - 1)))
  end
end
