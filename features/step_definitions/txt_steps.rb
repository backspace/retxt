World(Rack::Test::Methods)

When(/^I txt '(.*?)'$/) do |content|
  post '/txts/incoming', Body: content, From: my_number
end

Then(/^I should receive a (help|welcome) txt$/) do |message_type|
  if message_type == 'help'
    message = 'help message'
  elsif message_type == 'welcome'
    message = 'welcome'
  end

  response_should_include message_type
end

def response_should_include(content)
  Nokogiri::XML(last_response.body).xpath("//Sms").text.should include(content)
end
