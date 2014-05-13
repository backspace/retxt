class SentDirectMessageResponse < SimpleResponse
  private
  def template_name
    'direct.sent'
  end

  def template_parameters(recipient)
    {target_name: target_name}
  end

  def target_name
    # FIXME duplication of DirectMessage#target
    txt.body.split.first
  end
end
