class SubscriptionNotification
  def initialize(command_context)
    @context = command_context
  end

  def deliver(recipients)
    recipients.each do |recipient|
      SendsTxts.send_txt(
        from: @context.relay.number,
        to: recipient.number,
        originating_txt_id: @context.originating_txt_id,
        body: I18n.t('txts.admin.subscribed', name: @context.sender.name_or_anon, number: @context.sender.number, locale: recipient.locale)
      )
    end
  end
end
