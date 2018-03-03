class PrematureGroupMessageResponse < SimpleResponse
  private
  def template_name
    'group.premature'
  end

  def template_parameters(recipient)
    {meeting_code: meeting.code}
  end
end
