class AnswerResponse < SimpleResponse
  private
  def template_parameters(recipient)
    {portion: relay.answer[@context.meeting.index], host: URI.parse(ENV['LINK_HOST'] || "http://example.com").host}
  end
end
