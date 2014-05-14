class AnonRelayNotification < SimpleResponse
  private
  def template_name
    'admin.relay_identifier'
  end

  def template_parameters(recipient)
    {absolute_name: sender.absolute_name, beginning: txt.body[0..10]}
  end
end
