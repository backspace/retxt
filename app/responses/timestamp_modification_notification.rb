class TimestampModificationNotification < SimpleResponse
  private
  def template_name
    'admin.timestamp'
  end

  def template_parameters(recipient)
    {admin_name: sender.addressable_name, timestamp: arguments}
  end
end
