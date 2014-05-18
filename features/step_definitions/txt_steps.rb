World(Rack::Test::Methods)

When(/^I txt '(.*?)'( to relay (.*))?( at (.*))?$/) do |content, non_default_relay, relay_name, time_present, time|
  @txt_content = content

  if time_present
    Timecop.freeze Time.zone.parse(time)
  end

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

Then(/^(I|'(\w*)') should receive an? (already-subscribed|help|welcome|confirmation|directconfirmation|goodbye|created|no-anon-direct|non-admin|missing-target|moderated|unmoderated|timestamp|not-subscribed-notification|non-admin-attempt|frozen-bounce-notification|not-subscribed-bounce-notification) txt( in Pig Latin)?( from (\d+))?$/) do |subject, name, message_type, in_pig_latin, non_default_source, source|
  @original_locale = I18n.locale

  I18n.locale = :pgl if in_pig_latin.present?

  if subject == 'I'
    number = my_number
  else
    number = Subscriber.find_by(name: name).number
  end

  addressable_name = Subscriber.find_by(number: number).addressable_name

  if message_type == 'help'
    message = I18n.t('txts.help', subscriber_count: I18n.t('subscribers', count: Relay.first.subscriptions.count - 1))
  elsif message_type == 'welcome'
    message = I18n.t('txts.welcome', relay_name: Relay.first.name, subscriber_name: Subscriber.first.name_or_anon, subscriber_count: I18n.t('other', count: Relay.first.subscription_count - 1))
  elsif message_type == 'confirmation'
    message = I18n.t('txts.relayed', subscriber_count: I18n.t('subscribers', count: Relay.first.subscriptions.count - 1))
  elsif message_type == 'directconfirmation'
    message = I18n.t('txts.direct.sent', target_name: '@bob')
  elsif message_type == 'already-subscribed'
    message = 'you are already subscribed'
  elsif message_type == 'goodbye'
    message = 'goodbye'
  elsif message_type == 'created'
    message = I18n.t('txts.admin.creation', relay_name: Relay.all.sort_by(&:created_at).last.name, admin_name: Subscriber.first.addressable_name)
  elsif message_type == 'no-anon-direct'
    message = I18n.t('txts.direct.anonymous')
  elsif message_type == 'non-admin'
    message = I18n.t('txts.non_admin_bounce')
  elsif message_type == 'missing-target'
    message = I18n.t('txts.admin.missing_target', target: @txt_content.split(" ").last)
  elsif message_type == 'moderated'
    message = I18n.t('txts.admin.moderate', admin_name: addressable_name)
  elsif message_type == 'unmoderated'
    message = I18n.t('txts.admin.unmoderate', admin_name: addressable_name)
  elsif message_type == 'timestamp'
    content_words = @txt_content.split(" ")
    timestamp = content_words.length > 1 ? content_words.last : ""
    message = I18n.t('txts.admin.timestamp_modification', admin_name: addressable_name, timestamp: timestamp)
  elsif message_type == 'not-subscribed-notification'
    message = I18n.t('txts.admin.not_subscribed_relay_bounce', number: my_number, message: @txt_content)
  elsif message_type == 'non-admin-attempt'
    message = I18n.t('txts.admin.non_admin_bounce', sender_absolute_name: "anon##{my_number}", message: @txt_content)
  elsif message_type == 'frozen-bounce-notification'
    message = I18n.t('txts.admin.frozen_bounce', sender_absolute_name: "anon##{my_number}", message: @txt_content)
  elsif message_type == 'not-subscribed-bounce-notification'
    message = I18n.t('txts.admin.not_subscribed_unsubscribe_bounce', number: my_number, message: @txt_content)
  end

  if non_default_source
    response_should_include message, number, source
  else
    response_should_include message, number
  end

  I18n.locale = @original_locale
end

Then(/^I should receive a message that I am not subscribed$/) do
  response_should_include 'you are not subscribed'
end

Then(/^I should receive a message that the relay is frozen$/) do
  response_should_include I18n.t('txts.frozen_bounce')
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
      SendsTxts.should have_received(:send_txt).with(to: subscriber.number, body: txt, from: Relay.first.number, originating_txt_id: recent_txt_id).never
    else
      SendsTxts.should have_received(:send_txt).with(to: subscriber.number, body: txt, from: Relay.first.number, originating_txt_id: recent_txt_id)
    end
  end
end

Then(/^(the admin|'(\w*)') should receive a txt saying anon (un)?subscribed( in (English|Pig Latin))?$/) do |recipient, recipient_name, unsubscribed, language_present, language|
  if language_present
    locale = language == "English" ? :en : :pgl
  else
    locale = nil
  end

  if recipient_name
    admin = Subscriber.find_by(name: recipient_name)
  else
    admin = @admin
  end

  response_should_include I18n.t("txts.admin.#{unsubscribed ? 'un' : ''}subscription", name: 'anon', number: my_number, locale: locale), admin.number
end

Then(/^the admin should receive a txt saying 'bob' unsubscribed$/) do
  response_should_include I18n.t("txts.admin.unsubscription", name: 'bob', number: Subscriber.find_by(name: 'bob').number), @admin.number
end

Then(/^the admin should receive a txt including '([^']*)'$/) do |content|
  response_should_include content, Subscriber.find_by(admin: true).number
end

Then(/^(.*) should( not)? receive '(.*)'$/) do |name, negation, message|
  response_should_include(message, Subscriber.find_by(name: name).number) unless negation
end

Then(/^bob should receive '@alice sez: this message should not go to everyone' from relay A$/) do
  SendsTxts.should have_received(:send_txt).with(from: Relay.find_by(name: "A").number, to: Subscriber.find_by(name: "bob").number, body: "@alice sez: this message should not go to everyone", originating_txt_id: recent_txt_id)
end

Then(/^(.*) should not receive a message$/) do |name|
  page = Nokogiri::XML(last_response.body)
  page.xpath("//Sms[@to='#{Subscriber.find_by(name: name).number}']").should be_empty
end

Then(/^(\w*) should receive a txt including '([^']*)'$/) do |name, message|
  subscriber = name == 'I' ? Subscriber.find_by(number: @my_number) : Subscriber.find_by(name: name)

  SendsTxts.should have_received(:send_txt).with(to: subscriber.number, body: message, from: Relay.first.number, originating_txt_id: recent_txt_id)
end

def subscribers_other_than(subscriber)
  Subscriber.all - [subscriber]
end

def response_should_include(content, recipient_number = my_number, sender_number = nil)
  relay = @recent_relay || Relay.first
  SendsTxts.should have_received(:send_txt).with(from: relay.number || sender_number, to: recipient_number, body: content, originating_txt_id: recent_txt_id)
end

def response_should_not_include(content)
  Nokogiri::XML(last_response.body).xpath("//Sms[not(@to)]").text.should_not include(content)
end

def recent_txt_id
  Txt.where(originating_txt_id: nil).last ? Txt.where(originating_txt_id: nil).last.id.to_s : ''
end
