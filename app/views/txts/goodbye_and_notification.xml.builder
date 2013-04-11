xml.Response do
  @admins.each do |admin|
    xml.Sms("#{@unsubscriber.name_or_anon}/#{@unsubscriber.number} unsubscribed. :(", to: admin.number)
  end

  xml.Sms "goodbye"
end
