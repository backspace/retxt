xml.Response do
  xml.Sms(render(partial: 'direct_message_content', formats: [:text], locals: {subscriber_name: @subscriber.name, message: params[:Body]}).truncate(160), to: @recipient.number)
  xml.Sms render(partial: 'direct_message_success', formats: [:text], locals: {recipient_name: @recipient.name})
end
