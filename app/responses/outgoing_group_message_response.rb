class OutgoingGroupMessageResponse < SimpleResponse
  private
  def template_name
    'group.outgoing'
  end

  def template_parameters(recipient)
    {sender: sender.addressable_name, message: txt.body[(meeting.code.length + 2)..-1], meeting_code: meeting.code}
  end
end
