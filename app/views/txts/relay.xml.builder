xml.Response do
  @destinations.each do |number|
    xml.Sms("#{@subscriber.addressable_name} sez: #{params[:Body]}".truncate(160), to: number)
  end

  xml.Sms render(partial: 'relayed', formats: [:text], locals: {destination_count: @destinations.size})
end
