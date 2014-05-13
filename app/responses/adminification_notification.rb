class AdminificationNotification < SimpleResponse
  private
  def template_name
    'admin.admin'
  end

  def template_parameters(recipient)
    {adminer_name: sender.addressable_name, adminee_name: arguments}
  end
end
