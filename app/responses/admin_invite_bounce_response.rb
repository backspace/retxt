class AdminInviteBounceResponse < SimpleResponse
  private
  def template_name
    'admin.invite_bounce'
  end

  def template_parameters(recipient)
    {number: arguments}
  end
end
