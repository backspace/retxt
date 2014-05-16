class RenameNotification < SimpleResponse
  private
  def template_parameters(recipient)
    {admin_name: sender.name_or_anon, relay_name: arguments}
  end
end
