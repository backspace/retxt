class SubscriptionNotification < SimpleResponse
  private
  def template_name
    'admin.subscribed'
  end

  def template_parameters(recipient)
    {name: sender.name_or_anon, number: sender.number}
  end
end
