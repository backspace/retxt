class RelayCommand
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]

    @content = options[:content]
  end

  def execute
    if @relay.subscribed?(@sender)
      if @relay.frozen
        SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.frozen'))
      else
        if @relay.subscription_for(@sender).muted
          SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.muted_fail'))

          @relay.admins.each do |admin|
            SendsTxts.send_txt(from: @relay.number, to: admin.number, body: I18n.t('txts.muted_report', mutee_name: @sender.addressable_name, muted_message: @content))
          end
        else
          to_relay = RelayedTxtFormatter.new(sender: @sender, txt: @content).format

          (@relay.subscribers - [@sender]).each do |subscriber|
            SendsTxts.send_txt(from: @relay.number, to: subscriber.number, body: to_relay)
          end

          SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.relayed', subscriber_count: I18n.t('subscribers', count: @relay.subscribers.length - 1)))
        end
      end
    else
      SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.not_subscribed'))
    end
  end
end
