class RelayCommand
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]

    @i18n = options[:i18n] || I18n
    @sends_txts = options[:sends_txts] || SendsTxts

    @content = options[:content]
  end

  def execute
    if @relay.subscribed?(@sender)
      if @relay.frozen
        @sends_txts.send_txt(from: @relay.number, to: @sender.number, body: @i18n.t('txts.frozen'))
      else
        if @relay.subscription_for(@sender).muted
          @sends_txts.send_txt(from: @relay.number, to: @sender.number, body: @i18n.t('txts.muted_fail'))

          @relay.admins.each do |admin|
            @sends_txts.send_txt(from: @relay.number, to: admin.number, body: @i18n.t('txts.muted_report', mutee_name: @sender.addressable_name, muted_message: @content))
          end
        else
          to_relay = RelayedTxtFormatter.new(sender: @sender, txt: @content).format

          (@relay.subscribers - [@sender]).each do |subscriber|
            @sends_txts.send_txt(from: @relay.number, to: subscriber.number, body: to_relay)
          end

          @sends_txts.send_txt(from: @relay.number, to: @sender.number, body: @i18n.t('txts.relayed', subscriber_count: @i18n.t('subscribers', count: @relay.subscribers.length - 1)))
        end
      end
    else
      @sends_txts.send_txt(from: @relay.number, to: @sender.number, body: @i18n.t('txts.not_subscribed'))
    end
  end
end
