class WelcomeResponse < SimpleResponse
  private
  def template_parameters(recipient)
    other_subscribers = relay.subscription_count - 1
    other_subscribers_text = I18n.t('other', count: other_subscribers, locale: sender.locale)

    {relay_name: relay.name, subscriber_name: recipient.name_or_anon, subscriber_count: other_subscribers_text}
  end
end
