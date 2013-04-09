xml.Response do
  @destinations.each do |number|
    xml.Sms("#{@subscriber.nick_or_anon} sez: #{params[:Body]}", to: number)
  end

  xml.Sms render(partial: 'relayed', formats: [:text], locals: {destination_count: @destinations.size})
end
