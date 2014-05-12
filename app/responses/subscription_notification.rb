class SubscriptionNotification < SimpleResponse
  private
  def template_name
    'admin.subscribed'
  end

  def template_parameters(recipient)
    {name: @context.sender.name_or_anon, number: @context.sender.number}
  end
end
