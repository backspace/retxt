class BounceNotification
  def initialize(command_context)
    @context = command_context
  end

  def deliver(recipients)
    recipients.each do |recipient|
      SendsTxts.send_txt(
        from: @context.relay.number,
        to: recipient.number,
        originating_txt_id: @context.originating_txt_id,
        body: I18n.t('txts.bounce_notification', number: @context.sender.number, message: @context.txt.body, locale: recipient.locale)
      )
    end
  end
end
