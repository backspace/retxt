class Help
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]

    @i18n = options[:i18n] || I18n
    @sends_txts = options[:sends_txts] || SendsTxts

    @arguments = options[:arguments]
  end

  def execute
    @sends_txts.send_txt(from: @relay.number, to: @sender.number, body: @i18n.t('txts.help', subscriber_count: @i18n.t('subscribers', count: @relay.subscribers.length - 1)))
  end
end
