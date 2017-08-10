class DeletionNotification < SimpleResponse
  private
  def template_parameters(recipient)
    {admin_name: sender.addressable_name}
  end
end
