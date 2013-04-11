xml.Response do
  @admins.each do |admin|
    xml.Sms("#{@name} subscribed from #{@number}", to: admin.number)
  end

  xml.Sms render(partial: 'welcome', formats: [:text], locals: {subscriber_count: @subscriber_count, name: @name})
end
