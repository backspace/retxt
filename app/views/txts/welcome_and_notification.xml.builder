xml.Response do
  @admins.each do |admin|
    xml.Sms("#{@nick} subscribed from #{@number}", to: admin.number)
  end

  xml.Sms render(partial: 'welcome', formats: [:text], locals: {subscriber_count: @subscriber_count, nick: @nick})
end
