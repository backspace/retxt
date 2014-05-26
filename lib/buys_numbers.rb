class BuysNumbers
  def self.buy_number(area_code, country, sms_url, client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']))
    chosen_number = client.account.available_phone_numbers.get(country).local.list(area_code: area_code).first

    client.account.incoming_phone_numbers.create(phone_number: chosen_number.phone_number, sms_url: sms_url)

    chosen_number.phone_number
  end
end
