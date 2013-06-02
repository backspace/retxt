World(Rack::Test::Methods)

When(/^I txt '(.*?)'( to relay (.*))?$/) do |content, non_default_relay, relay_name|
  @txt_content = content

  if non_default_relay
    @recent_relay = Relay.find_by(name: relay_name)
    post '/txts/incoming', Body: content, From: my_number, To: @recent_relay.number
  else
    post '/txts/incoming', Body: content, From: my_number
  end
end

When(/^'(\w*)' txts '([^']*)'( to relay A)?$/) do |name, content, relay_given|
  @txt_content = content
  relay = relay_given ? Relay.find_by(name: 'A') : Relay.first
  post '/txts/incoming', Body: content, From: Subscriber.find_by(name: name).number, To: relay.number
end

Then(/^I should receive an? (already-subscribed|help|welcome|confirmation|directconfirmation|goodbye|created|non-admin|moderated|unmoderated) txt( from (\d+))?$/) do |message_type, non_default_source, source|
  my_addressable_name = Subscriber.find_by(number: my_number).addressable_name

  if message_type == 'help'

    message = I18n.t('txts.help', subscriber_count: I18n.t('subscribers', count: Relay.first.subscriptions.count - 1))
  elsif message_type == 'welcome'
    message = 'welcome'
  elsif message_type == 'confirmation'
    message = I18n.t('txts.relayed', subscriber_count: I18n.t('subscribers', count: Relay.first.subscriptions.count - 1))
  elsif message_type == 'directconfirmation'
    message = I18n.t('txts.direct.sent', target_name: '@bob')
  elsif message_type == 'already-subscribed'
    message = 'you are already subscribed'
  elsif message_type == 'goodbye'
    message = 'goodbye'
  elsif message_type == 'created'
    message = I18n.t('txts.admin.create', relay_name: 'B', admin_name: 'anon')
  elsif message_type == 'non-admin'
    message = I18n.t('txts.nonadmin')
  elsif message_type == 'moderated'
    message = I18n.t('txts.admin.moderate', admin_name: my_addressable_name)
  elsif message_type == 'unmoderated'
    message = I18n.t('txts.admin.unmoderate', admin_name: my_addressable_name)
  end

  if non_default_source
    response_should_include message, my_number, source
  else
    response_should_include message
  end
end

Then(/^I should receive a message that I am not subscribed$/) do
  response_should_include 'you are not subscribed'
end

Then(/^I should receive a message that the relay is frozen$/) do
  response_should_include I18n.t('txts.frozen')
end

Then(/^I should not receive a txt including '(.*)'$/) do |content|
  response_should_not_include content
end

Then(/^'(\w*)' should receive a txt including '(.*)'$/) do |name, content|
  response_should_include content, Subscriber.find_by(name: name).number
end

Then(/^I should receive a txt including$/) do |content|
  response_should_include content
end


Then(/^subscribers other than (\w*) should( not)? receive that message( signed by '(.*?)')?$/) do |name, negation, signature_exists, signature|
  txt = "#{signature == 'anon' ? '' : '@'}#{signature} sez: #{@txt_content}"

  subject = name == 'me' ? Subscriber.find_by(number: my_number) : Subscriber.find_by(name: name)

  subscribers_other_than(subject).each do |subscriber|
    if negation
      SendsTxts.should have_received(:send_txt).with(to: subscriber.number, body: txt, from: Relay.first.number).never
    else
      SendsTxts.should have_received(:send_txt).with(to: subscriber.number, body: txt, from: Relay.first.number)
    end
  end
end

Then(/^the admin should receive a txt saying anon (un)?subscribed$/) do |unsubscribed|
  response_should_include I18n.t("txts.admin.#{unsubscribed ? 'un' : ''}subscribed", name: 'anon', number: my_number), @admin.number
end

Then(/^the admin should receive a txt saying 'bob' unsubscribed$/) do
  response_should_include I18n.t("txts.admin.unsubscribed", name: 'bob', number: my_number), @admin.number
end

Then(/^the admin should receive a txt including '([^']*)'$/) do |content|
  response_should_include content, Subscriber.find_by(admin: true).number
end

Then(/^(.*) should( not)? receive '(.*)'$/) do |name, negation, message|
  response_should_include(message, Subscriber.find_by(name: name).number) unless negation
end

Then(/^bob should receive '@alice sez: this message should not go to everyone' from relay A$/) do
  SendsTxts.should have_received(:send_txt).with(from: Relay.find_by(name: "A").number, to: Subscriber.find_by(name: "bob").number, body: "@alice sez: this message should not go to everyone")
end

Then(/^(.*) should not receive a message$/) do |name|
  page = Nokogiri::XML(last_response.body)
  page.xpath("//Sms[@to='#{Subscriber.find_by(name: name).number}']").should be_empty
end

Then(/^(\w*) should receive a txt including '([^']*)'$/) do |name, message|
  subscriber = name == 'I' ? Subscriber.find_by(number: @my_number) : Subscriber.find_by(name: name)

  SendsTxts.should have_received(:send_txt).with(to: subscriber.number, body: message, from: Relay.first.number)
end

def subscribers_other_than(subscriber)
  Subscriber.all - [subscriber]
end

def response_should_include(content, recipient_number = my_number, sender_number = nil)
  relay = @recent_relay || Relay.first
  SendsTxts.should have_received(:send_txt).with(from: relay.number || sender_number, to: recipient_number, body: content)
end

def response_should_not_include(content)
  Nokogiri::XML(last_response.body).xpath("//Sms[not(@to)]").text.should_not include(content)
end
