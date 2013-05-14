When(/^I visit the subscribers list$/) do
  visit subscribers_path
end

Then(/^I should( not)? see myself$/) do |negation|
  page.send(negation ? :should_not : :should, have_content(my_number))
end

Then(/^I should have sent (\d+) messages?$/) do |message_count|
  page.find("#subscriber_#{Subscriber.find_by(number: my_number).id} .sent").should have_content(message_count)
end

Then(/^I should see that relay B has number (\d+)$/) do |number|
  page.find("#relay_#{Relay.find_by(name: 'B').id} .number").should have_content(number)
end

Then(/^I should see that I am subscribed to relay (\w*)$/) do |relay_name|
  relay = Relay.find_by(name: relay_name)
  subscriber = Subscriber.find_by(number: my_number)

  page.should have_selector(".relay_#{relay.id}.subscriber_#{subscriber.id}")
end

Then(/^I should( not)? see that '(\w*)' is subscribed to relay (\w*)$/) do |negation, subscriber_name, relay_name|
  relay = Relay.find_by(name: relay_name)
  subscriber = Subscriber.find_by(name: subscriber_name)

  matcher = negation ? :should_not : :should

  page.send(matcher, have_selector(".relay_#{relay.id}.subscriber_#{subscriber.id}"))
end
