class NotifyMeetingResponse < SimpleResponse
  def template_parameters(recipient)
    {others: (meeting.subscribers - [recipient]).map(&:addressable_name).to_sentence, region: meeting.region}
  end
end
