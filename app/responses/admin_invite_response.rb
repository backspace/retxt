class AdminInviteResponse < SimpleResponse
  private
  def template_name
    'admin.invite'
  end

  def template_parameters(recipient)
    {number: arguments, admin_name: sender.name}
  end
end
