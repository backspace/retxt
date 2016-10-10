class AlreadyInvitedInviteBounceResponse < SimpleResponse
  private
  def template_name
    'admin.already_invited_invite_bounce_response'
  end

  def template_parameters(recipient)
    {number: arguments}
  end
end
