class WelcomeResponse
  def initialize(command_context)
    @context = command_context
  end

  def deliver(recipient)
    other_subscribers = @context.relay.subscription_count - 1
    other_subscribers_text = I18n.t('other', count: other_subscribers, locale: @context.sender.locale)

    SendsTxts.send_txt(from: @context.relay.number, to: recipient.number, body: I18n.t('txts.welcome', relay_name: @context.relay.name, subscriber_name: recipient.name_or_anon, subscriber_count: other_subscribers_text, locale: @context.sender.locale), originating_txt_id: @context.originating_txt_id)
  end
end
