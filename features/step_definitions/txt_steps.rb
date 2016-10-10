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
    relay = Relay.first
    relay = Relay.create unless relay
    post '/txts/incoming', Body: content, From: my_number, To: relay.number
  end
end

When(/^(\w*) txts '([^']*)'( to relay A)?$/) do |name, content, relay_given|
  @txt_content = content
  relay = relay_given ? Relay.find_by(name: 'A') : Relay.first
  post '/txts/incoming', Body: content, From: Subscriber.find_by(name: name).number, To: relay.number
end

Then(/^(I|(\w*)) should receive an? (help|welcome|not-subscribed-bounce-notification) txt( in Pig Latin)?( from (\d+))?$/) do |subject, name, message_type, in_pig_latin, non_default_source, source|
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
  end

  if non_default_source
    txt_should_have_been_sent message, number, source
  else
    txt_should_have_been_sent message, number
  end

  I18n.locale = @original_locale
end

Then(/^I should receive an? (\w*) help txt$/) do |command|
  message =
    case command
    when 'unknown'
      I18n.t('txts.command_help.unknown', command: @txt_content.split.last)
    when 'admin'
      I18n.t('txts.admin.help')
    else
      I18n.t("txts.command_help.#{command}")
    end

  txt_should_have_been_sent message, my_number
end

Then(/^I should receive a txt including$/) do |content|
  txt_should_have_been_sent content
end

Then(/^(\w*) should receive a txt that (\w*) made (\w*) (not )?an admin$/) do |recipient, actor, actee, negation|
  template_name = "#{negation ? 'un' : ''}adminification"
  recipient_number = Subscriber.find_by(name: recipient).number
  txt_should_have_been_sent I18n.t("txts.admin.#{template_name}", admin_name: "@#{actor}", target_name: "@#{actee}"), recipient_number
end

Then(/^subscribers other than (\w*) should( not)? receive that( ([^\s]*)-timestamped)? message( signed by (.*?))?$/) do |name, negation, timestamp_exists, timestamp, signature_exists, signature|
  prefix = timestamp_exists ? "#{timestamp} " : ''
  subject = name == 'me' ? Subscriber.find_by(number: my_number) : Subscriber.find_by(name: name)

  subscribers_other_than(subject).each do |subscriber|
    txt = I18n.t('txts.relay_template', time: prefix, sender: subject.addressable_name, body: @txt_content, locale: subscriber.locale)

    if negation
      SendsTxts.should have_received(:send_txt).with(to: subscriber.number, body: txt, from: Relay.first.number, originating_txt_id: recent_txt_id).never
    else
      SendsTxts.should have_received(:send_txt).with(to: subscriber.number, body: txt, from: Relay.first.number, originating_txt_id: recent_txt_id)
    end
  end
end

Then(/^(the admin|(\w*)) should receive a txt saying anon (un)?subscribed( in (English|Pig Latin))?$/) do |recipient, recipient_name, unsubscribed, language_present, language|
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

  txt_should_have_been_sent I18n.t("txts.admin.#{unsubscribed ? 'un' : ''}subscription", name: 'anon', number: my_number, locale: locale), admin.number
end

Then(/^(\w*) should receive a txt that (\w*) (closed subscriptions|opened subscriptions|froze the relay|thawed the relay|moderated the relay|unmoderated the relay)$/) do |recipient, admin_name, action|
  recipient_number = recipient == 'I' ? my_number : Subscriber.find_by(name: recipient).number

  template_name =
    case action
    when 'closed subscriptions'
      'close'
    when 'opened subscriptions'
      'open'
    when 'froze the relay'
      'freeze'
    when 'thawed the relay'
      'thaw'
    when 'moderated the relay'
      'moderate'
    when 'unmoderated the relay'
      'unmoderate'
    else
      'missing!'
    end

  txt_should_have_been_sent I18n.t("txts.admin.#{template_name}", admin_name: "#{admin_name == 'anon' ? '' : '@'}#{admin_name}"), recipient_number
end

Then(/^(\w*) should receive a txt( in (Pig Latin|English))? that (subscriptions are closed|the relay is moderated|they are muted|identifies the sender of the anonymous message|they are unsubscribed|I could not be unsubscribed|I am already subscribed|confirms the message was relayed|confirms the direct message was sent|a relay was created|anonymous subscribers cannot send direct messages|I am not an admin|the target could not be found|someone tried to unsubscribe that is not subscribed|the relay is frozen|I am not subscribed|my language has been changed to Pig Latin|my language has been changed to English|the language was not found|the command failed because I am not subscribed|lists the available languages)( from (\d+))?$/) do |recipient, language_given, language_name, response_name, source_given, source|
  recipient_number = recipient == 'I' ? my_number : Subscriber.find_by(name: recipient).number
  locale = language_given ? (language_name == 'Pig Latin' ? :pgl : :en) : :en

  response_text =
    I18n.with_locale(locale) do
      case response_name
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
      when 'I am already subscribed'
        I18n.t('txts.already_subscribed_bounce')
      when 'confirms the message was relayed'
        I18n.t('txts.relayed', subscriber_count: I18n.t('subscribers', count: Relay.first.subscriptions.count - 1))
      when 'confirms the direct message was sent'
        I18n.t('txts.direct.sent', target_name: '@Bob')
      when 'a relay was created'
        I18n.t('txts.admin.creation', relay_name: Relay.all.sort_by(&:created_at).last.name, admin_name: Subscriber.first.addressable_name)
      when 'anonymous subscribers cannot send direct messages'
        I18n.t('txts.direct.anonymous')
      when 'I am not an admin'
        I18n.t('txts.non_admin_bounce')
      when 'the target could not be found'
        I18n.t('txts.admin.missing_target', target: @txt_content.split(" ").last)
      when 'someone tried to unsubscribe that is not subscribed'
        I18n.t('txts.admin.not_subscribed_unsubscribe_bounce', number: my_number, message: @txt_content)
      when 'the relay is frozen'
        I18n.t('txts.frozen_bounce')
      when 'I am not subscribed'
        I18n.t('txts.not_subscribed_relay_bounce')
      when 'my language has been changed to Pig Latin', 'my language has been changed to English'
        I18n.t('txts.language')
      when 'the language was not found'
        I18n.t('txts.language_bounce')
      when 'the command failed because I am not subscribed'
        I18n.t('txts.not_subscribed_command_bounce')
      when 'lists the available languages'
        I18n.t('txts.language_list', language_list: "english, igpay atinlay")
      else
        'missing!'
      end
    end

  if source_given
    txt_should_have_been_sent response_text, recipient_number, source
  else
    txt_should_have_been_sent response_text, recipient_number
  end
end

Then(/^(\w*) should receive a txt that (\w*) tried to (subscribe|relay a message under moderation|relay a message while muted|relay a message while not subscribed|run an admin command|relay a message while the relay is frozen|switch to an unknown language|switch languages while not subscribed)$/) do |recipient, sender_name, action|
  recipient_number = Subscriber.find_by(name: recipient).number
  sender = Subscriber.find_by(name: sender_name == 'anon' || sender_name == 'someone' ? nil : sender_name)

  response_text =
    case action
    when 'subscribe'
      I18n.t('txts.admin.closed_bounce', number: sender.number, message: @txt_content)
    when 'relay a message under moderation'
      I18n.t('txts.admin.moderated_bounce', subscriber_name: sender.absolute_name, moderated_message: @txt_content)
    when 'relay a message while muted'
      I18n.t('txts.admin.muted_bounce', mutee_name: sender.addressable_name, muted_message: @txt_content)
    when 'relay a message while not subscribed'
      I18n.t('txts.admin.not_subscribed_relay_bounce', number: my_number, message: @txt_content)
    when 'run an admin command'
      I18n.t('txts.admin.non_admin_bounce', sender_absolute_name: "anon##{my_number}", message: @txt_content)
    when 'relay a message while the relay is frozen'
      I18n.t('txts.admin.frozen_bounce', sender_absolute_name: "anon##{my_number}", message: @txt_content)
    when 'switch to an unknown language'
      I18n.t('txts.admin.language_bounce', sender_absolute_name: sender.absolute_name, message: @txt_content)
    when 'switch languages while not subscribed'
      I18n.t('txts.admin.not_subscribed_command_bounce', sender_absolute_name: sender.absolute_name, message: @txt_content)
    else
      'missing!'
    end

  txt_should_have_been_sent response_text, recipient_number
end

Then(/^(\w*) should receive a txt that (\w*) (voiced|unvoiced|muted|unmuted|renamed the relay to|set the relay timestamp to) ([^\s]*)$/) do |recipient_name, admin_name, action, target_name|
  recipient_number = recipient_name == 'I' ? my_number : Subscriber.find_by(name: recipient_name).number

  response_text =
    case action
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
    when 'set the relay timestamp to'
      I18n.t('txts.admin.timestamp_modification', admin_name: "@#{admin_name}", timestamp: target_name == 'blank' ? '' : target_name)
    else
      'missing!'
    end

  txt_should_have_been_sent response_text, recipient_number
end

Then(/^I should receive a txt saying Bob unsubscribed$/) do
  txt_should_have_been_sent I18n.t("txts.admin.unsubscription", name: 'Bob', number: Subscriber.find_by(name: 'Bob').number), my_number
end

Then(/^Alice should receive a txt that (\d+) was invited$/) do |number|
  txt_should_have_been_sent I18n.t("txts.admin.invite", admin_name: "Alice", number: number), Subscriber.find_by(name: 'Alice').number
end

Then(/^Alice should receive a txt that (\d+) was already invited$/) do |number|
  txt_should_have_been_sent I18n.t("txts.admin.already_invited_invite_bounce_response", admin_name: "Alice", number: number), Subscriber.find_by(name: 'Alice').number
end

Then(/^Alice should receive a txt that (\d+) was already subscribed$/) do |number|
  txt_should_have_been_sent I18n.t("txts.admin.already_subscribed_invite_bounce", number: number), Subscriber.find_by(name: 'Alice').number
end

Then(/^(\d+) should receive an invitation$/) do |number|
  txt_should_have_been_sent I18n.t('txts.invite', relay_name: ''), number
end

# FIXME lessen coupling to relay template

Then(/^Bob should receive '@Alice says: this message should not go to everyone' from relay A$/) do
  SendsTxts.should have_received(:send_txt).with(from: Relay.find_by(name: "A").number, to: Subscriber.find_by(name: "Bob").number, body: "@Alice says: this message should not go to everyone", originating_txt_id: recent_txt_id)
end

Then(/^(.*) should not receive a message$/) do |name|
  number = Subscriber.find_by(name: name).number
  Mocha::Mockery.instance.invocations.select{|invocation| invocation.method_name == :send_txt && invocation.arguments[0][:to] == number}.should be_empty
end

Then(/^Bob should receive a( ([^\s]*)-timestamped)? direct message from Alice saying '([^\']*)'$/) do |timestamp_present, timestamp, message_content|
  recipient_number = Subscriber.find_by(name: 'Bob').number
  prefix = timestamp_present ? "#{timestamp} " : ''

  txt_should_have_been_sent I18n.t('txts.direct.outgoing', prefix: prefix, sender: '@Alice', message: @txt_content), recipient_number
end

Then(/^Colleen should not receive a direct message from Alice saying 'you are kewl'$/) do
  recipient_number = Subscriber.find_by(name: 'Colleen').number

  txt_should_not_have_been_sent I18n.t('txts.direct.outgoing', prefix: '', sender: '@Alice', message: @txt_content), recipient_number
end

Then(/^I should receive a direct message bounce response because @Francine could not be found$/) do
  txt_should_have_been_sent I18n.t('txts.direct.missing_target', target_name: '@Francine'), my_number
end

def subscribers_other_than(subscriber)
  Subscriber.all - [subscriber]
end

def txt_should_have_been_sent(content, recipient_number = my_number, sender_number = nil)
  relay = @recent_relay || Relay.first
  SendsTxts.should have_received(:send_txt).with(from: sender_number || relay.number, to: recipient_number, body: content, originating_txt_id: recent_txt_id)
end

def txt_should_not_have_been_sent(content, recipient_number = my_number, sender_number = nil)
  relay = @recent_relay || Relay.first
  SendsTxts.should have_received(:send_txt).with(from: relay.number || sender_number, to: recipient_number, body: content, originating_txt_id: recent_txt_id).never
end

def recent_txt_id
  Txt.where(originating_txt_id: nil).last ? Txt.where(originating_txt_id: nil).asc(:created_at).last.id.to_s : ''
end
