message_strings = who_messages(@subscribers)

xml.Response do
  message_strings.each do |string|
    xml.Sms string
  end
end
