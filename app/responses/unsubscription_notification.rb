class UnsubscriptionNotification < SimpleResponse
  private
  def template_name
    'admin.unsubscribed'
  end

  def template_parameters(recipient)
    {number: sender.number, name: sender.name_or_anon}
  end
end
