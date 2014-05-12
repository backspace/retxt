class BounceNotification < SimpleResponse
  private
  def template_name
    'bounce_notification'
  end

  def template_parameters(recipient)
    {number: @context.sender.number, message: @context.txt.body}
  end
end
