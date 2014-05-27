def my_number
  if defined? @me
    @me.number
  else
    '+12045551313'
  end
end

def create_relay_with_subscriber(name, subscriber)
  relay = Relay.find_or_create_by(name: name)

  relay.update_attribute(:number, "+1514555000#{Relay.count}") unless relay.number.present?

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

  create_relay_with_subscriber(relay_name, subscriber)
  subscriber.update_attribute(:admin, true) if admin
  @me = subscriber
end

Given(/^two other people are subscribed$/) do
  create_relay_with_subscriber(nil, Subscriber.create(number: '5145551313'))
  create_relay_with_subscriber(nil, Subscriber.create(number: '4385551313'))
end

Given(/^someone is subscribed( to relay (\w*))?( as (\w*))?( at (\d*))?$/) do |non_default_relay, relay_name, name_given, name, number_given, number|
  subscriber = Subscriber.create(number: Time.now.to_f)

  subscriber.update_attribute(:name, name) if name_given

  if number_given
    subscriber.update_attribute(:number, number)
  end

  create_relay_with_subscriber(relay_name, subscriber)
end

Given(/^an admin is subscribed$/) do
  @admin = Subscriber.create(number: '6045551313')
  @admin.admin = true
  @admin.save

  create_relay_with_subscriber(nil, @admin)
end

Given(/^(\w*) is subscribed( as an admin)?( in (English|Pig Latin))?$/) do |name, admin_present, language_present, language|
  subscriber = Subscriber.create(number: Time.now.to_f, name: name)
  subscriber.admin = true if admin_present

  if language_present
    subscriber.locale = language == 'English' ? :en : :pgl
  end

  subscriber.save

  create_relay_with_subscriber(nil, subscriber)
end
