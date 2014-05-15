class ClosedBounceNotification < SimpleResponse
  def template_parameters(recipient)
    {number: sender.number, message: txt.body}
  end
end
