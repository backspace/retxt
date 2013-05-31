class SendsTxts
  def self.send_txt(options)
    client = options[:client] || Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])

    client.account.sms.messages.create(
      to: options[:to],
      from: options[:from],
      body: truncate(options[:body])
    )
  end

  def self.send_txts(options)
    splitter = Splitter.new(options[:body])

    splitter.split.each do |txt|
      send_txt(to: options[:to], from: options[:from], body: txt)
    end
  end

  private
  def self.truncate(text)
    if text.length > 160
      text.truncate(160)
    else
      text
    end
  end
end
