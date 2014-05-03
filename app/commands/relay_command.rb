class RelayCommand
  def initialize(command_context)
    @sender = command_context.sender
    @relay = command_context.relay

    @txt = command_context.txt
    @content = @txt.body
  end

  def execute
    if @relay.subscribed?(@sender)
      if @relay.frozen
        SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.frozen'))
      elsif @relay.moderated && !@sender.admin && !@relay.subscription_for(@sender).voiced
        SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.moderated_fail'))

        TxtsRelayAdmins.txt_relay_admins(relay: @relay, body: I18n.t('txts.moderated_report', subscriber_name: @sender.absolute_name, moderated_message: @content))
      else
        if @relay.subscription_for(@sender).muted
          SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.muted_fail'))

          @relay.admins.each do |admin|
            SendsTxts.send_txt(from: @relay.number, to: admin.number, body: I18n.t('txts.muted_report', mutee_name: @sender.addressable_name, muted_message: @content))
          end
        else
          to_relay = RelayedTxtFormatter.new(relay: @relay, sender: @sender, txt: @txt).format

          (@relay.subscribers - [@sender]).each do |subscriber|
            SendsTxts.send_txt(from: @relay.number, to: subscriber.number, body: to_relay)
          end

          SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.relayed', subscriber_count: I18n.t('subscribers', count: @relay.subscribers.length - 1)))

          if @sender.anonymous?
            TxtsRelayAdmins.txt_relay_admins(relay: @relay, body: I18n.t('txts.relay_identifier', absolute_name: @sender.absolute_name, beginning: @content[0..10]))
          end
        end
      end
    else
      SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.not_subscribed'))
    end
  end
end
