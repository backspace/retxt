class DeletionNotification < SimpleResponse
  private
  def template_name
    'admin.delete'
  end

  def template_parameters
    {admin_name: sender.addressable_name}
  end
end
