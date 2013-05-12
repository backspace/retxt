class DeletesRelays
  def self.delete_relay(options)
    client = options[:client] || Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
    relay = options[:relay]

    client.account.incoming_phone_numbers.find(phone_number: relay.number).delete

    relay.destroy

    substitute_relay_number = client.account.incoming_phone_numbers.list.first.phone_number

    client.account.sms.messages.create(
      to: options[:subscriber].number,
      from: substitute_relay_number,
      body: "the relay #{relay.name} was deleted"
    )
  end
end
