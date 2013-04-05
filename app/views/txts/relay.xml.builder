xml.Response do
  @destinations.each do |number|
    xml.Sms(params[:Body], to: number)
  end

  xml.Sms "your message was sent to #{pluralize @destinations.size, 'subscriber'}"
end
