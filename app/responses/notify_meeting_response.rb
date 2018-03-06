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
    if meeting.chosen == recipient
      chosen_text = "When you convene"
    else
      chosen_text = "You are not chosen, but if the chosen person is missing"
    end

    team_code_blanks = meeting.teams.map{|team| team == recipient.team ? team.code : "[sigil for #{team.addressable_name}]"}.join('')
    {chosen_text: chosen_text, others: (meeting.teams - [recipient.team]).map(&:addressable_name).to_sentence, region: meeting.region, code: meeting.code, team_code_blanks: team_code_blanks}
  end
end
