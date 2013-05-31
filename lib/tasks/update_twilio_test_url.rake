desc "updates Twilio test application URL"
task :update_twilio, [:host] => [:environment] do |t, args|
  tunnel = LocalTunnel::Tunnel.new(3000, nil)
  response = tunnel.register_tunnel

  new_url = "http://#{response['host']}/txts/incoming"

  client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])

  test_application = client.account.applications.list(name: "SSSR").first

  test_application.update(sms_url: new_url)

  Rails.logger.info "Updated Twilio to point test application to #{new_url}"

  tunnel.start_tunnel
end
