Given(/^team (\w*)( with code (\d+))? is (.*)$/) do |team_name, code_present, code, subscriber_names|
  subscribers = subscriber_names.split(', ').map do |name|
    Subscriber.create(number: Time.now.to_f, name: name)
  end

  create_relay_with_subscriber(nil, subscribers.first)
  relay = Relay.first
  subscribers[1..-1].each do |subscriber|
    relay.subscriptions << Subscription.create(subscriber: subscriber, relay: relay)
  end

  team = Team.create(name: team_name, subscribers: subscribers)

  if code_present
    team.update_attribute(:code, code)
  end
end

Given(/^I am on team (\w*)( with code (\d+))?$/) do |team_name, code_present, code|
  subscriber = Subscriber.find_or_create_by(name: 'me', number: my_number)

  create_relay_with_subscriber(nil, subscriber)
  @me = subscriber

  team = Team.create(name: team_name, subscribers: [subscriber])

  if code_present
    team.update_attribute(:code, code)
  end
end

Given(/^(\w+) is on team (\w+)$/) do |subscriber_name, team_name|
  subscriber = Subscriber.create(number: Time.now.to_f, name: subscriber_name)
  Relay.first.subscriptions << Subscription.create(subscriber: subscriber, relay: Relay.first)
  Team.find_by(name: team_name).subscribers << subscriber
end

Given(/^I am subscribed as (\w*) with code (\d+)$/) do |name, code|
  subscriber = Subscriber.find_or_create_by(number: my_number)
  subscriber.update_attribute(:name, name)
  subscriber.update_attribute(:code, code)

  create_relay_with_subscriber(nil, subscriber)
  @me = subscriber
end

Given(/^someone is subscribed as (\w*) with code (\d+)$/) do |name, code|
  subscriber = Subscriber.create(number: Time.now.to_f)
  subscriber.update_attribute(:name, name)
  subscriber.update_attribute(:code, code)

  create_relay_with_subscriber(nil, subscriber)
end

Given(/^a ((\w*)-chosen )?meeting (\w*) at (\w*)( with answer (\w*))? is scheduled( at offset (\d+))? between (.*)$/) do |chosen_container, chosen, code, region, answer_container, answer, offset_container, offset, team_names|
  teams = team_names.split(", ").map{|name| Team.find_by(name: name)}

  meeting = Meeting.create(teams: teams, code: code, offset: offset || 0, region: region, index: 0)

  if chosen_container
    meeting.chosen = Subscriber.find_by(name: chosen)
    meeting.save
  end

  if answer_container
    meeting.answer = answer
    meeting.save
  end
end

Given(/^a message 'hello there' from beyond is scheduled at offset (\d+)$/) do |offset|
  Broadcast.create(offset: offset.to_i, content: '@beyond says hello there')
end

Given(/^it is offset (\d+)$/) do |offset|
  Timecop.freeze Relay.first.start + offset.to_i.minutes
end

Given(/^the relay start is set to (.*)$/) do |datetime_string|
  Relay.first.update_attribute(:start, Time.zone.parse(datetime_string))
end

Given(/^the final answer is correct horse battery staple$/) do
  Relay.first.update_attribute(:answer, %w(correct horse battery staple))
end

When(/^the txts are sent$/) do
  post '/txts/trigger'
end

Then(/^I should receive a txt with links for a meeting (\w*) at (\w*)$/) do |code, region|
  meeting = Meeting.first
  url = Rails.application.routes.url_helpers.meeting_path(meeting.id, host: "example.com")
  txt_should_have_been_sent "A RESPONSE #{url}", @me.number
end

Then(/^I should receive a txt that the codes were not recognised$/) do
  txt_should_have_been_sent I18n.t('txts.question_bounce'), @me.number
end

Then(/^Jorty should receive a copy of the direct message from Alice to Bob saying 'you are kewl'$/) do
  recipient_number = Subscriber.find_by(name: 'Jorty').number

  txt_should_have_been_sent I18n.t('txts.direct.copy', prefix: '', sender: '@Alice', message: '@bob you are kewl'), recipient_number
end

Then(/^(\w*) should receive a (chosen )?message about the meeting at (\w*)$/) do |subscriber_name, chosen, region|
  subscriber = Subscriber.find_by(name: subscriber_name)
  recipient_number = subscriber.number

  # FIXME meetings shouldn’t have names unless they’re a compound of subscriber names
  meeting = Meeting.where(region: region).first

  others = meeting.teams - [subscriber.team]
  others_string = others.map(&:addressable_name).to_sentence

  if chosen
    txt_should_have_been_sent I18n.t('txts.notify_chosen_meeting', others: others_string, region: meeting.region, code: "&#{meeting.code}"), recipient_number
  else
    txt_should_have_been_sent I18n.t('txts.notify_meeting', others: others_string, region: meeting.region, code: "&#{meeting.code}"), recipient_number
  end
end

Then(/^(\w*) should have only received (\d+) messages?$/) do |subscriber_name, count|
  recipient_number = Subscriber.find_by(name: subscriber_name).number
  Mocha::Mockery.instance.invocations.select{|invocation| invocation.method_name == :send_txt }
    .map(&:arguments).map(&:first)
    .select{|arguments| arguments[:to] == recipient_number}.length.should eq(count.to_i)
end

Then(/^I should receive a response that the meeting group (\w*) cannot yet be messaged$/) do |meeting_code|
  txt_should_have_been_sent I18n.t('txts.group.premature', meeting_code: meeting_code)
end

Then(/^(\w*) should receive a confirmation that (my|their) message was sent to meeting group (\w*)$/) do |recipient, pronoun, meeting_code|
  if recipient == 'I'
    txt_should_have_been_sent I18n.t('txts.group.sent', meeting_code: meeting_code)
  else
    txt_should_have_been_sent I18n.t('txts.group.sent', meeting_code: meeting_code), Subscriber.find_by(name: recipient).number
  end
end

Then(/^(\w*) should receive '(.*)'$/) do |recipient_name, message_content|
  recipient_number = Subscriber.find_by(name: recipient_name).number
  txt_should_have_been_sent message_content, recipient_number
end

Then(/^(\w*) should receive '(.*)' with no origin$/) do |recipient_name, message_content|
  recipient_number = Subscriber.find_by(name: recipient_name).number
  txt_should_have_been_sent_no_origin message_content, recipient_number
end

Then(/^I should receive a txt with a portion of the final answer$/) do
  txt_should_have_been_sent I18n.t('txts.answer', portion: "correct")
end

Then(/^I should receive a txt that the answer was incorrect$/) do
  txt_should_have_been_sent I18n.t('txts.answer_incorrect_bounce')
end

Then(/^I should receive a txt that the meeting was not found$/) do
  txt_should_have_been_sent I18n.t('txts.answer_meeting_bounce')
end
