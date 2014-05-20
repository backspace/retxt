if Rails.env.development?
  if ENV['TWILIO_ACCOUNT_SID'] && ENV['TWILIO_AUTH_TOKEN'] && ENV['RETXT_SUBDOMAIN']
    puts "Updating Twilio phone number SMS URLs"
    client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])

    endpoint = "http://#{ENV['RETXT_SUBDOMAIN']}.ngrok.com/txts/incoming"

    Relay.all.each do |relay|
      phone_number = client.account.incoming_phone_numbers.list({phone_number: relay.number}).first

      if phone_number.sms_url != endpoint
        phone_number.update sms_url: endpoint
        puts "Updated #{relay.number} SMS URL to #{endpoint}"
      else
        puts "#{relay.number} already has SMS URL #{endpoint}"
      end
    end

    puts "Done.\n\n"
  else
    puts "Unable to update Twilio number URLs with ngrok URL due to missing environment variables. Configure .env as described in the README and run with foreman.\n\n"
  end
end
