class ModeratedBounceNotification < SimpleResponse
  private
  def template_name
    'moderated_report'
  end

  def template_parameters(recipient)
    {subscriber_name: sender.absolute_name, moderated_message: txt.body}
  end
end
