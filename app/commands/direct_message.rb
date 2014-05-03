class DirectMessage
  def initialize(command_context)
    @sender = command_context.sender
    @relay = command_context.relay

    @txt = command_context.txt
    @content = @txt.body
  end

  def execute
    if @relay.subscribed?(@sender)
      if @sender.anonymous?
        SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.direct.anonymous'))
      else
        target_subscriber = FindsSubscribers.find(target)

        if target_subscriber
          SendsTxts.send_txt(from: @relay.number, to: target_subscriber.number, body: I18n.t('txts.direct.outgoing', prefix: TimestampFormatter.new(relay: @relay, txt: @txt).format, sender: @sender.addressable_name, message: @content))

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
