class NotifyMeetingResponse < SimpleResponse
  def deliver(recipient)
    if meeting.chosen == recipient
      @template_name_override = 'notify_chosen_meeting'
    else
      @template_name_override = 'notify_meeting'
    end

    super
  end

  private
  def template_name
    @template_name_override
  end

  def template_parameters(recipient)
    {others: (meeting.teams - [recipient.team]).map(&:addressable_name).to_sentence, region: meeting.region, code: "&#{meeting.code}"}
  end
end
