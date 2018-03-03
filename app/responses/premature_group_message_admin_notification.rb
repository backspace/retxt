class PrematureGroupMessageAdminNotification < SimpleResponse
  private
  def template_name
    'group.premature_admin'
  end

  def template_parameters(recipient)
    {sender: @context.sender.addressable_name, body: @context.originating_txt.body}
  end
end
