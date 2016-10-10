class AlreadySubscribedInviteBounceResponse < SimpleResponse
  private
  def template_name
    'admin.already_subscribed_invite_bounce'
  end

  def template_parameters(recipient)
    {number: arguments}
  end
end
