World(Rack::Test::Methods)

When(/^I txt '(.*?)'$/) do |content|
  @txt_content = content
  post '/txts/incoming', Body: content, From: my_number
end

Then(/^I should receive an? (already-subscribed|help|welcome|confirmation) txt$/) do |message_type|
  if message_type == 'help'
    message = 'help message'
  elsif message_type == 'welcome'
    message = 'welcome'
  elsif message_type == 'confirmation'
    message = 'your message was sent'
  elsif message_type == 'already-subscribed'
    message = 'you are already subscribed'
  end

  response_should_include message
end

Then(/^subscribers other than me should receive that message$/) do
  page = Nokogiri::XML(last_response.body)

  subscribers_other_than_me.each do |subscriber|
    page.xpath("//Sms[@to='#{subscriber.number}']").text.should include(@txt_content)
  end
end

def subscribers_other_than_me
  Subscriber.all - [Subscriber.find_by(number: my_number)]
end

def response_should_include(content)
  Nokogiri::XML(last_response.body).xpath("//Sms[not(@to)]").text.should include(content)
end
