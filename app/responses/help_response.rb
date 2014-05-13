class HelpResponse < SimpleResponse
  private
  def template_parameters(recipient)
    {subscriber_count: I18n.t('subscribers', count: relay.subscribers.length - 1)}
  end
end
