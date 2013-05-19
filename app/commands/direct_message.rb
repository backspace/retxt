class DirectMessage
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]

    @i18n = options[:i18n] || I18n
    @sends_txts = options[:sends_txts] || SendsTxts

    @content = options[:content]
  end

  def execute
    if @relay.subscribed?(@sender)
      if @sender.anonymous?
        @sends_txts.send_txt(from: @relay.number, to: @sender.number, body: @i18n.t('txts.direct.anonymous'))
      else
        target_subscriber = FindsSubscribers.find(target)

        if target_subscriber
          @sends_txts.send_txt(from: @relay.number, to: target_subscriber.number, body: @i18n.t('txts.direct.outgoing', sender: @sender.addressable_name, message: @content))

          @sends_txts.send_txt(from: @relay.number, to: @sender.number, body: @i18n.t('txts.direct.sent', target_name: target))
        else
          @sends_txts.send_txt(from: @relay.number, to: @sender.number, body: @i18n.t('txts.direct.missing_target', target_name: target))
        end
      end
    end
  end

  private
  def target
    @content.split.first
  end
end
