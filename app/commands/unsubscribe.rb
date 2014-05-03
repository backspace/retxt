class Unsubscribe
  def initialize(command_context)
    @command_context = command_context
    @sender = command_context.sender
    @relay = command_context.relay
  end

  def execute
    if @relay.subscribed?(@sender)
      subscription = @relay.subscription_for(@sender)
      subscription.destroy

      SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.goodbye'), originating_txt_id: @command_context.originating_txt_id)

      TxtsRelayAdmins.txt_relay_admins(relay: @relay, body: I18n.t('txts.admin.unsubscribed', number: @sender.number, name: @sender.name_or_anon), originating_txt_id: @command_context.originating_txt_id)
    else
      SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.not_subscribed'), originating_txt_id: @command_context.originating_txt_id)
    end
  end
end
