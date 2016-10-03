class InviteResponse < SimpleResponse
  private
  def template_parameters(recipient)
    {relay_name: relay.name}
  end
end
