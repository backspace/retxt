class AdminificationNotification < SimpleResponse
  private
  def template_parameters(recipient)
    {admin_name: sender.addressable_name, target_name: arguments}
  end
end
