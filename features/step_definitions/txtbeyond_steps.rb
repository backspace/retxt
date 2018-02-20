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

Given(/^a meeting M is scheduled between US, GX, GY$/) do
  subscribers = [
    Subscriber.find_by(name: "US"),
    Subscriber.find_by(name: "GX"),
    Subscriber.find_by(name: "GY")
  ]

  Meeting.create(subscribers: subscribers)
end

Then(/^I should receive a txt with links for meeting M$/) do
  txt_should_have_been_sent "A RESPONSE", @me.number
end

Then(/^Jorty should receive a copy of the direct message from Alice to Bob saying 'you are kewl'$/) do
  recipient_number = Subscriber.find_by(name: 'Jorty').number

  txt_should_have_been_sent I18n.t('txts.direct.copy', prefix: '', sender: '@Alice', message: '@bob you are kewl'), recipient_number
end
