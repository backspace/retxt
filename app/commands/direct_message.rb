class DirectMessage
  def initialize(command_context)
    @command_context = command_context
    @sender = command_context.sender
    @relay = command_context.relay

    @txt = command_context.txt
    @content = @txt.body
  end

  def execute
    if @relay.subscribed?(@sender)
      if @sender.anonymous?
        SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.direct.anonymous'), originating_txt_id: @command_context.originating_txt_id)
      else
        target_subscriber = FindsSubscribers.find(target)

        if target_subscriber
          SendsTxts.send_txt(from: @relay.number, to: target_subscriber.number, body: I18n.t('txts.direct.outgoing', prefix: TimestampFormatter.new(relay: @relay, txt: @txt).format, sender: @sender.addressable_name, message: @content), originating_txt_id: @command_context.originating_txt_id)

          SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.direct.sent', target_name: target), originating_txt_id: @command_context.originating_txt_id)
        else
          SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.direct.missing_target', target_name: target), originating_txt_id: @command_context.originating_txt_id)
        end
      end
    end
  end

  private
  def target
    @content.split.first
  end
end
