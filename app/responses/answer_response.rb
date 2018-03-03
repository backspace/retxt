class AnswerResponse < SimpleResponse
  private
  def template_parameters(recipient)
    {portion: relay.answer[@context.meeting.index]}
  end
end
