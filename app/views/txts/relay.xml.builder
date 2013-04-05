xml.Response do
  @destinations.each do |number|
    xml.Sms("#{@subscriber.nick_or_anon} sez: #{params[:Body]}", to: number)
  end

  xml.Sms "your message was sent to #{pluralize @destinations.size, 'subscriber'}"
end
