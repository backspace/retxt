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

Given(/^a meeting (\w*) is scheduled( at offset (\d+))? between (.*)$/) do |code, offset_container, offset, subscriber_names|
  subscribers = subscriber_names.split(", ").map{|name| Subscriber.find_by(name: name)}

  Meeting.create(subscribers: subscribers, code: code, offset: offset || 0)
end

Given(/^it is offset (\d+)$/) do |offset|
  Timecop.freeze Meeting::START + offset.to_i.minutes
end

When(/^the txts are sent$/) do
  post '/txts/trigger'
end

Then(/^I should receive a txt with links for meeting M$/) do
  txt_should_have_been_sent "A RESPONSE", @me.number
end

Then(/^I should receive a txt that the codes were not recognised$/) do
  txt_should_have_been_sent I18n.t('txts.bang_bounce'), @me.number
end

Then(/^Jorty should receive a copy of the direct message from Alice to Bob saying 'you are kewl'$/) do
  recipient_number = Subscriber.find_by(name: 'Jorty').number

  txt_should_have_been_sent I18n.t('txts.direct.copy', prefix: '', sender: '@Alice', message: '@bob you are kewl'), recipient_number
end

Then(/^(\w*) should receive a message about meeting (\w*)$/) do |subscriber_name, meeting_name|
  recipient_number = Subscriber.find_by(name: subscriber_name).number

  # FIXME meetings shouldn’t have names unless they’re a compound of subscriber names
  meeting = Meeting.first

  txt_should_have_been_sent I18n.t('txts.notify_meeting'), recipient_number
end
