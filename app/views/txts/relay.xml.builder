xml.Response do
  xml.Sms render(partial: 'relayed', formats: [:text], locals: {destination_count: @destinations.size})
end
