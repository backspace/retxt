class DirectMessage
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]

    @content = options[:content]
  end

  def execute
    if @relay.subscribed?(@sender)
      if @sender.anonymous?
        SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.direct.anonymous'))
      else
        target_subscriber = FindsSubscribers.find(target)

        if target_subscriber
          SendsTxts.send_txt(from: @relay.number, to: target_subscriber.number, body: I18n.t('txts.direct.outgoing', sender: @sender.addressable_name, message: @content))

          SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.direct.sent', target_name: target))
        else
          SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.direct.missing_target', target_name: target))
        end
      end
    end
  end

  private
  def target
    @content.split.first
  end
end
