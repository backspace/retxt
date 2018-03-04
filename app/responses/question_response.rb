class QuestionResponse < SimpleResponse
  private
  def template_parameters(recipient)
    {url: Rails.application.routes.url_helpers.meeting_url(meeting.id, host: ENV['LINK_HOST'], only_path: Rails.env.test?)}
  end
end
