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
    message = I18n.t('txts.already_subscribed_bounce')
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
  response_should_include I18n.t('txts.not_subscribed_relay_bounce')
end

Then(/^I should receive a message that the relay is frozen$/) do
  response_should_include I18n.t('txts.frozen_bounce')
end

Then(/^I should receive a txt including$/) do |content|
  response_should_include content
end

Then(/^(\w*) should receive a txt that (\w*) made (\w*) (not )?an admin$/) do |recipient, actor, actee, negation|
  template_name = "#{negation ? 'un' : ''}adminification"
  recipient_number = Subscriber.find_by(name: recipient).number
  response_should_include I18n.t("txts.admin.#{template_name}", admin_name: "@#{actor}", target_name: "@#{actee}"), recipient_number
end

Then(/^subscribers other than (\w*) should( not)? receive that( ([^\s]*)-timestamped)? message( signed by '(.*?)')?$/) do |name, negation, timestamp_exists, timestamp, signature_exists, signature|
  prefix = timestamp_exists ? "#{timestamp} " : ''
  txt = "#{prefix}#{signature == 'anon' ? '' : '@'}#{signature} sez: #{@txt_content}"

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

Then(/^(\w*) should receive a txt that (\w*) (closed subscriptions|opened subscriptions|froze the relay|thawed the relay)$/) do |recipient, admin_name, action|
  recipient_number = recipient == 'I' ? my_number : Subscriber.find_by(name: recipient).number

  template_name = case action
                  when 'closed subscriptions'
                    'close'
                  when 'opened subscriptions'
                    'open'
                  when 'froze the relay'
                    'freeze'
                  when 'thawed the relay'
                    'thaw'
                  else
                    'missing!'
                  end

  response_should_include I18n.t("txts.admin.#{template_name}", admin_name: "@#{admin_name}"), recipient_number
end

Then(/^(\w*) should receive a txt that (subscriptions are closed|the relay is moderated|they are muted|identifies the sender of the anonymous message|they are unsubscribed|I could not be unsubscribed)$/) do |recipient, response_name|
  recipient_number = recipient == 'I' ? my_number : Subscriber.find_by(name: recipient).number

  response_text = case response_name
                  when 'subscriptions are closed'
                    I18n.t('txts.close')
                  when 'the relay is moderated'
                    I18n.t('txts.moderated_fail')
                  when 'they are muted'
                    I18n.t('txts.muted_fail')
                  when 'identifies the sender of the anonymous message'
                    I18n.t('txts.admin.anon_relay', beginning: "#{@txt_content[0..10]}", absolute_name: Subscriber.find_by(number: my_number).absolute_name)
                  when 'they are unsubscribed'
                    I18n.t('txts.goodbye')
                  when 'I could not be unsubscribed'
                    I18n.t('txts.not_subscribed_unsubscribe_bounce')
                  else
                    'missing!'
                  end

  response_should_include response_text, recipient_number
end

Then(/^(\w*) should receive a txt that (\w*) tried to (subscribe|relay a message under moderation|relay a message while muted)$/) do |recipient, sender_name, action|
  recipient_number = Subscriber.find_by(name: recipient).number
  sender = Subscriber.find_by(name: sender_name)

  response_text = case action
                  when 'subscribe'
                    I18n.t('txts.admin.closed_bounce', number: sender.number, message: @txt_content)
                  when 'relay a message under moderation'
                    I18n.t('txts.admin.moderated_bounce', subscriber_name: sender.absolute_name, moderated_message: @txt_content)
                  when 'relay a message while muted'
                    I18n.t('txts.admin.muted_bounce', mutee_name: sender.addressable_name, muted_message: @txt_content)
                  else
                    'missing!'
                  end

  response_should_include response_text, recipient_number
end

Then(/^(\w*) should receive a txt that (\w*) (voiced|unvoiced|muted|unmuted|renamed the relay to) (\w*)$/) do |recipient_name, admin_name, action, target_name|
  recipient_number = recipient_name == 'I' ? my_number : Subscriber.find_by(name: recipient_name).number

  response_text = case action
                  when 'voiced'
                    I18n.t('txts.admin.voice', admin_name: "@#{admin_name}", target_name: "@#{target_name}")
                  when 'unvoiced'
                    I18n.t('txts.admin.unvoice', admin_name: "@#{admin_name}", target_name: "@#{target_name}")
                  when 'muted'
                    I18n.t('txts.admin.mute', admin_name: "@#{admin_name}", target_name: "@#{target_name}")
                  when 'unmuted'
                    I18n.t('txts.admin.unmute', admin_name: "@#{admin_name}", target_name: "@#{target_name}")
                  when 'renamed the relay to'
                    I18n.t('txts.admin.rename', admin_name: 'anon', relay_name: target_name)
                  else
                    'missing!'
                  end

  response_should_include response_text, recipient_number
end

Then(/^the admin should receive a txt saying 'bob' unsubscribed$/) do
  response_should_include I18n.t("txts.admin.unsubscription", name: 'bob', number: Subscriber.find_by(name: 'bob').number), @admin.number
end

Then(/^bob should receive '@alice sez: this message should not go to everyone' from relay A$/) do
  SendsTxts.should have_received(:send_txt).with(from: Relay.find_by(name: "A").number, to: Subscriber.find_by(name: "bob").number, body: "@alice sez: this message should not go to everyone", originating_txt_id: recent_txt_id)
end

Then(/^(.*) should not receive a message$/) do |name|
  page = Nokogiri::XML(last_response.body)
  page.xpath("//Sms[@to='#{Subscriber.find_by(name: name).number}']").should be_empty
end

Then(/^bob should receive a( ([^\s]*)-timestamped)? direct message from alice saying '([^\']*)'$/) do |timestamp_present, timestamp, message_content|
  recipient_number = Subscriber.find_by(name: 'bob').number
  prefix = timestamp_present ? "#{timestamp} " : ''

  response_should_include I18n.t('txts.direct.outgoing', prefix: prefix, sender: '@alice', message: @txt_content), recipient_number
end

Then(/^colleen should not receive a direct message from alice saying 'you are kewl'$/) do
  # FIXME add not-received check
end

Then(/^I should receive a direct message bounce response because @francine could not be found$/) do
  response_should_include I18n.t('txts.direct.missing_target', target_name: '@francine'), my_number
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
