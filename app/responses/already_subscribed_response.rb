class AlreadySubscribedResponse
  def initialize(command_context)
    @context = command_context
  end

  def deliver(recipient)
    SendsTxts.send_txt(from: @context.relay.number, to: recipient.number, body: I18n.t('txts.already_subscribed', locale: recipient.locale), originating_txt_id: @context.originating_txt_id)
  end
end
