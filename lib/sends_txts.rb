class SendsTxts
  def self.send_txt(options)
    client = options[:client] || Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])

    body = truncate(options[:body])

    client.account.sms.messages.create(
      to: options[:to],
      from: options[:from],
      body: body
    )

    Txt.create(
      to: options[:to],
      from: options[:from],
      body: body,
      originating_txt_id: options[:originating_txt_id]
    )
  end

  def self.send_txts(options)
    splitter = Splitter.new(options[:body])

    splitter.split.each do |txt|
      send_txt(to: options[:to], from: options[:from], body: txt, originating_txt_id: options[:originating_txt_id])
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
