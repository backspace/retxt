class NotSubscribedBounceNotification < SimpleResponse
  private
  def template_parameters(recipient)
    {number: sender.number, message: txt.body}
  end
end
