xml.Response do
  xml.Sms "Your direct message to #{@recipient} failed: #{@recipient} was not found."
end
