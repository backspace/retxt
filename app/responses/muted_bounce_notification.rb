class MutedBounceNotification < SimpleResponse
  private
  def template_name
    'admin.muted_report'
  end

  def template_parameters(recipient)
    {mutee_name: sender.addressable_name, muted_message: txt.body}
  end
end
