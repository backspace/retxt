class OutgoingGroupMessageResponse < SimpleResponse
  private
  def template_name
    'group.outgoing'
  end

  def template_parameters(recipient)
    if sender.team && sender.name != sender.team.name
      sender_string = "@#{sender.name} of @#{sender.team.name}"
    else
      sender_string = "@#{sender.name}"
    end

    {sender: sender_string, message: txt.body[(meeting.code.length + 2)..-1], meeting_code: meeting.code}
  end
end
