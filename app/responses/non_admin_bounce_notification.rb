class NonAdminBounceNotification < SimpleResponse
  private
  def template_parameters(recipient)
    {sender_absolute_name: sender.absolute_name, message: txt.body}
  end
end
