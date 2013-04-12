xml.Response do
  xml.Sms("@#{@subscriber.name} said to you: #{params[:Body]}", to: @recipient.number)
  xml.Sms "your message was sent to @#{@recipient.name}"
end
