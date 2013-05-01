xml.Response do
  xml.Sms "did not forward your message because you have been muted by an admin"

  @admin_destinations.each do |destination|
    xml.Sms "#{@mutee.addressable_name} tried to say: #{@original_message}".truncate(160), to: destination
  end
end
