World(Rack::Test::Methods)

When(/^I txt '(.*?)'( to relay (.*))?$/) do |content, non_default_relay, relay_name|
  @txt_content = content

  if non_default_relay
    post '/txts/incoming', Body: content, From: my_number, To: Relay.find_by(name: relay_name).number
  else
    post '/txts/incoming', Body: content, From: my_number
  end
end

When(/^'bob' txts '(\w*)' to relay A$/) do |content|
  post '/txts/incoming', Body: content, From: Subscriber.find_by(name: 'bob').number, To: Relay.find_by(name: 'A').number
end

Then(/^I should receive an? (already-subscribed|help|welcome|confirmation|goodbye|created) txt( from (\d+))?$/) do |message_type, non_default_source, source|
  if message_type == 'help'
    message = 'cmds'
  elsif message_type == 'welcome'
    message = 'welcome'
  elsif message_type == 'confirmation'
    message = 'your message was sent'
  elsif message_type == 'already-subscribed'
    message = 'you are already subscribed'
  elsif message_type == 'goodbye'
    message = 'goodbye'
  elsif message_type == 'created'
    message = 'created'
  end

  response_should_include message

  if non_default_source
    Nokogiri::XML(last_response.body).xpath("//Sms[@from='#{source}']").should_not be_empty
  end
end

Then(/^I should receive a message that I am not subscribed$/) do
  response_should_include 'you are not subscribed'
end

Then(/^I should receive a message that the relay is frozen$/) do
  response_should_include 'frozen'
end

Then(/^I should receive a txt including '(.*)'$/) do |content|
  response_should_include content
end

Then(/^subscribers other than me should( not)? receive that message( signed by '(.*?)')?$/) do |negation, signature_exists, signature|
  page = Nokogiri::XML(last_response.body)
  matcher = negation ? :should_not : :should

  subscribers_other_than_me.each do |subscriber|
    message_text = page.xpath("//Sms[@to='#{subscriber.number}']").text
    message_text.send(matcher, include(@txt_content))

    if !negation && signature_exists
      message_text.should include(signature)
    end
  end
end

Then(/^the admin should receive a txt saying anon (un)?subscribed$/) do |unsubscribed|
  page = Nokogiri::XML(last_response.body)
  admin_text = page.xpath("//Sms[@to='#{@admin.number}']").text

  admin_text.should include('anon')
  admin_text.should include(unsubscribed ? 'unsubscribed' : 'subscribed')
end

Then(/^the admin should receive a txt saying 'bob' unsubscribed$/) do
  admin_text = Nokogiri::XML(last_response.body).xpath("//Sms[@to='#{@admin.number}']").text

  admin_text.should include('bob')
  admin_text.should include('unsubscribed')
end

Then(/^(.*) should( not)? receive '(.*)'$/) do |name, negation, message|
  page = Nokogiri::XML(last_response.body)
  text = page.xpath("//Sms[@to='#{Subscriber.find_by(name: name).number}']").text

  text.send(negation ? :should_not : :should, include(message))
end

Then(/^(.*) should not receive a message$/) do |name|
  page = Nokogiri::XML(last_response.body)
  page.xpath("//Sms[@to='#{Subscriber.find_by(name: name).number}']").should be_empty
end

def subscribers_other_than_me
  Subscriber.all - [Subscriber.where(number: my_number).first]
end

def response_should_include(content)
  Nokogiri::XML(last_response.body).xpath("//Sms[not(@to)]").text.should include(content)
end
