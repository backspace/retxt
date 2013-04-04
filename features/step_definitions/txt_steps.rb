World(Rack::Test::Methods)

When(/^I txt 'help'$/) do
  post '/txts/incoming', Body: 'help'
end

Then(/^I should receive a help txt$/) do
  page = Nokogiri::XML(last_response.body)
  page.xpath("//Sms").text.should include('help message')
end
