class ModifySubscription
  def initialize(command_context, options = {})
    @command_context = command_context
    @sender = command_context.sender
    @relay = command_context.relay
    @arguments = command_context.arguments

    @modifier = options[:modifier]
    @success_message = options[:success_message]
  end

  def execute
    return reject_unless_admin unless @sender.admin
    return reject_missing_target unless target = FindsSubscribers.find(@arguments)
    return reject_unsubscribed_target unless @subscription = @relay.subscription_for(target)

    modify_subscription
    notify_admins
  end

  private
  def reject_unless_admin
    SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.nonadmin'), originating_txt_id: @command_context.originating_txt_id)
  end

  def reject_missing_target
    SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.missing_target', target: @arguments), originating_txt_id: @command_context.originating_txt_id)
  end

  def reject_unsubscribed_target
    SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.unsubscribed_target', target: @arguments), originating_txt_id: @command_context.originating_txt_id)
  end

  def modify_subscription
    @modifier.call(@subscription)
  end

  def notify_admins
    TxtsRelayAdmins.txt_relay_admins(relay: @relay, body: @success_message, originating_txt_id: @command_context.originating_txt_id)
  end
end
