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

Given(/^a ((\w*)-chosen )?meeting (\w*) at (\w*)( with answer (\w*))? is scheduled( at offset (\d+))? between (.*)$/) do |chosen_container, chosen, code, region, answer_container, answer, offset_container, offset, subscriber_names|
  subscribers = subscriber_names.split(", ").map{|name| Subscriber.find_by(name: name)}

  meeting = Meeting.create(subscribers: subscribers, code: code, offset: offset || 0, region: region)

  if chosen_container
    meeting.chosen = Subscriber.find_by(name: chosen)
    meeting.save
  end

  if answer_container
    meeting.answer = answer
    meeting.save
  end
end

Given(/^it is offset (\d+)$/) do |offset|
  Timecop.freeze Meeting::START + offset.to_i.minutes
end

When(/^the txts are sent$/) do
  post '/txts/trigger'
end

Then(/^I should receive a txt with links for a meeting (\w*) at (\w*)$/) do |code, region|
  txt_should_have_been_sent "A RESPONSE", @me.number
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

  others = meeting.subscribers - [subscriber]
  others_string = others.map(&:addressable_name).to_sentence

  if chosen
    txt_should_have_been_sent I18n.t('txts.notify_chosen_meeting', others: others_string, region: meeting.region), recipient_number
  else
    txt_should_have_been_sent I18n.t('txts.notify_meeting', others: others_string, region: meeting.region), recipient_number
  end
end

Then(/^(\w*) should have only received (\d+) message$/) do |subscriber_name, count|
  recipient_number = Subscriber.find_by(name: subscriber_name).number
  Mocha::Mockery.instance.invocations.select{|invocation| invocation.method_name == :send_txt }
    .map(&:arguments).map(&:first)
    .select{|arguments| arguments[:to] == recipient_number}.length.should eq(count.to_i)
end

Then(/^I should receive a confirmation that my message was sent to meeting group (\w*)$/) do |meeting_code|
  txt_should_have_been_sent I18n.t('txts.group.sent', meeting_code: meeting_code)
end

Then(/^(\w*) should receive '(.*)'$/) do |recipient_name, message_content|
  recipient_number = Subscriber.find_by(name: recipient_name).number
  txt_should_have_been_sent message_content, recipient_number
end

Then(/^I should receive a txt with a portion of the final answer$/) do
  txt_should_have_been_sent I18n.t('txts.answer')
end

Then(/^I should receive a txt that the answer was incorrect$/) do
  txt_should_have_been_sent I18n.t('txts.answer_incorrect_bounce')
end
