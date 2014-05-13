class UnadminificationNotification < SimpleResponse
  private
  def template_name
    'admin.unadmin'
  end

  def template_parameters(recipient)
    {unadminer_name: sender.addressable_name, unadminee_name: arguments}
  end
end
