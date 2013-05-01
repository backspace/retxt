def my_number
  '2045551313'
end

def create_relay_with_subscriber(name, subscriber)
  relay = Relay.find_or_create_by(name: name)

  relay.update_attribute(:number, Time.now.to_f) unless relay.number.present?

  relay.subscriptions << Subscription.create(subscriber: subscriber, relay: relay)
end

Given(/^I am subscribed( to relay (\w*))?( as an admin)?$/) do |non_default_relay, relay_name, admin|
  subscriber = Subscriber.create(number: my_number)

  if non_default_relay
    create_relay_with_subscriber(relay_name, subscriber)
  else
    relay = Relay.first || Relay.create
    Subscription.create(relay: relay, subscriber: subscriber)
  end

  subscriber.update_attribute(:admin, true) if admin
end

Given(/^I am subscribed( to relay (\w*))? as '(\w*)'$/) do |non_default_relay, relay_name, name|
  subscriber = Subscriber.create(number: my_number, name: name)

  create_relay_with_subscriber(non_default_relay ? relay_name : nil, subscriber)
end

Given(/^two other people are subscribed$/) do
  relay = Relay.first || Relay.create

  Subscription.create(subscriber: Subscriber.create(number: '5145551313'), relay: relay)
  Subscription.create(subscriber: Subscriber.create(number: '4385551313'), relay: relay)
end

Given(/^someone is subscribed( to relay (.*))? as '(.*)'$/) do |non_default_relay, relay_name, name|
  subscriber = Subscriber.create(number: Time.now.to_f, name: name)

  create_relay_with_subscriber(relay_name, subscriber) if non_default_relay
end

Given(/^an admin is subscribed$/) do
  @admin = Subscriber.create(number: '6045551313')
  @admin.admin = true
  @admin.save
end

When(/^I visit the subscribers list$/) do
  visit subscribers_path
end

Then(/^I should( not)? see myself$/) do |negation|
  page.send(negation ? :should_not : :should, have_content(my_number))
end

Then(/^I should have sent (\d+) messages?$/) do |message_count|
  page.find("#subscriber_#{Subscriber.find_by(number: my_number).id} .sent").should have_content(message_count)
end
