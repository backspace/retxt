class DeletesRelays
  def self.delete_relay(options)
    client = options[:client] || Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
    relay = options[:relay]

    client.account.incoming_phone_numbers.list(phone_number: relay.number).first.delete

    relay.destroy
  end
end
