class OutgoingDirectMessageResponse < SimpleResponse
  private
  def template_name
    'direct.outgoing'
  end

  def template_parameters(recipient)
    {prefix: TimestampFormatter.new(relay: relay, txt: txt).format, sender: sender.addressable_name, message: txt.body}
  end
end
