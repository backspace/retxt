class RelayCommand
  def initialize(command_context)
    @command_context = command_context
    @sender = command_context.sender
    @relay = command_context.relay

    @txt = command_context.txt
    @content = @txt.body
  end

  def execute
    return not_subscribed unless sender_subscribed?
    return frozen if @relay.frozen
    return suppress_voiceless if relay_moderated_and_sender_voiceless?
    return muted if sender_muted?

    relay
  end

  private
  def sender_subscribed?
    @relay.subscribed?(@sender)
  end

  def not_subscribed
    SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.not_subscribed'), originating_txt_id: @command_context.originating_txt_id)
  end

  def frozen
    SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.frozen'), originating_txt_id: @command_context.originating_txt_id)
  end

  def relay_moderated_and_sender_voiceless?
    @relay.moderated && !@sender.admin && !@relay.subscription_for(@sender).voiced
  end

  def suppress_voiceless
    SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.moderated_fail'), originating_txt_id: @command_context.originating_txt_id)

    TxtsRelayAdmins.txt_relay_admins(relay: @relay, body: I18n.t('txts.moderated_report', subscriber_name: @sender.absolute_name, moderated_message: @content), originating_txt_id: @command_context.originating_txt_id)
  end

  def sender_muted?
    @relay.subscription_for(@sender).muted
  end

  def muted
    SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.muted_fail'), originating_txt_id: @command_context.originating_txt_id)

    TxtsRelayAdmins.txt_relay_admins(relay: @relay, body: I18n.t('txts.muted_report', mutee_name: @sender.addressable_name, muted_message: @content), originating_txt_id: @command_context.originating_txt_id)
  end

  def relay
    to_relay = RelayedTxtFormatter.new(relay: @relay, sender: @sender, txt: @txt).format

    (@relay.subscribers - [@sender]).each do |subscriber|
      SendsTxts.send_txt(from: @relay.number, to: subscriber.number, body: to_relay, originating_txt_id: @command_context.originating_txt_id)
    end

    SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.relayed', subscriber_count: I18n.t('subscribers', count: @relay.subscribers.length - 1)), originating_txt_id: @command_context.originating_txt_id)

    identify_anonymous_to_admins if @sender.anonymous?
  end

  def identify_anonymous_to_admins
    TxtsRelayAdmins.txt_relay_admins(relay: @relay, body: I18n.t('txts.relay_identifier', absolute_name: @sender.absolute_name, beginning: @content[0..10]), originating_txt_id: @command_context.originating_txt_id)
  end
end
