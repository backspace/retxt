class BounceNotification < SimpleResponse
  private
  def template_name
    'admin.bounce_notification'
  end

  def template_parameters(recipient)
    {number: sender.number, message: txt.body}
  end
end
