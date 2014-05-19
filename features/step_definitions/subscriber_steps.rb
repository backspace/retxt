def my_number
  @my_number ||= '2045551313'
end

def create_relay_with_subscriber(name, subscriber)
  relay = Relay.find_or_create_by(name: name)

  relay.update_attribute(:number, Time.now.to_f) unless relay.number.present?

  relay.subscriptions << Subscription.create(subscriber: subscriber, relay: relay)
end

Given(/^I am subscribed( to relay (\w*))?( as an admin)?( as (\w*))?( at (\d*))?$/) do |non_default_relay, relay_name, admin, name_given, name, number_given, number|
  subscriber = Subscriber.find_or_create_by(number: my_number)

  if name_given
    subscriber.update_attribute(:name, name)
  end

  if number_given
    subscriber.update_attribute(:number, number) 
    @my_number = number
  end

  if non_default_relay
    create_relay_with_subscriber(relay_name, subscriber)
  else
    relay = Relay.first || Relay.create
    Subscription.create(relay: relay, subscriber: subscriber)
  end

  subscriber.update_attribute(:admin, true) if admin
end

Given(/^two other people are subscribed$/) do
  relay = Relay.first || Relay.create

  Subscription.create(subscriber: Subscriber.create(number: '5145551313'), relay: relay)
  Subscription.create(subscriber: Subscriber.create(number: '4385551313'), relay: relay)
end

Given(/^someone is subscribed( to relay (\w*))?( as (\w*))?( at (\d*))?$/) do |non_default_relay, relay_name, name_given, name, number_given, number|
  subscriber = Subscriber.create(number: Time.now.to_f)

  subscriber.update_attribute(:name, name) if name_given

  if number_given
    subscriber.update_attribute(:number, number)
  end

  if non_default_relay
    create_relay_with_subscriber(relay_name, subscriber)
  else
    relay = Relay.first || Relay.create
    Subscription.create(relay: relay, subscriber: subscriber)
  end
end

Given(/^an admin is subscribed$/) do
  @admin = Subscriber.create(number: '6045551313')
  @admin.admin = true
  @admin.save

  relay = Relay.first || Relay.create

  Subscription.create(relay: relay, subscriber: @admin)
end

Given(/^(\w*) is subscribed as an admin( in (English|Pig Latin))?$/) do |name, language_present, language|
  subscriber = Subscriber.create(number: Time.now.to_f, name: name)
  subscriber.admin = true

  if language_present
    subscriber.locale = language == 'English' ? :en : :pgl
  end

  subscriber.save

  relay = Relay.first || Relay.create

  Subscription.create(relay: relay, subscriber: subscriber)
end
