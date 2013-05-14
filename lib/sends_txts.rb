class SendsTxts
  def self.send_txt(options)
    client = options[:client] || Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])

    client.account.sms.messages.create(
      to: options[:to],
      from: options[:from],
      body: options[:body]
    )
  end
end
