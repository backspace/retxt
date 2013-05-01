xml.Response do
  xml.Sms 'subscriptions are closed'

  @admin_destinations.each do |number|
    xml.Sms "#{params[:From]} tried to subscribe: #{params[:Body]}", to: number
  end
end
