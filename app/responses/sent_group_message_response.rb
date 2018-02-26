class SentGroupMessageResponse < SimpleResponse
  private
  def template_name
    'group.sent'
  end

  def template_parameters(recipient)
    {meeting_code: meeting.code}
  end

  def target_name
    # FIXME duplication of DirectMessage#target
    txt.body.split.first
  end
end
