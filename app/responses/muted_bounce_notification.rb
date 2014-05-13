class MutedBounceNotification < SimpleResponse
  private
  def template_name
    'muted_report'
  end

  def template_parameters(recipient)
    {mutee_name: sender.addressable_name, muted_message: txt.body}
  end
end
