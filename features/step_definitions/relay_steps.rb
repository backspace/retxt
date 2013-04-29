Given(/^the number buyer will buy number (\d+)$/) do |number|
  BuysNumbers.stub(:buy_number).and_return(number)
end

Then(/^I should see that relay B has number (\d+)$/) do |number|
  page.find("#relay_#{Relay.find_by(name: 'B').id} .number").should have_content(number)
end

Then(/^I should see that I am subscribed to relay B$/) do
  relay = Relay.find_by(name: 'B')
  subscriber = Subscriber.find_by(number: my_number)

  page.should have_selector(".relay_#{relay.id}.subscriber_#{subscriber.id}")
end

Then(/^I should not see that 'bob' is subscribed to relay B$/) do
  relay = Relay.find_by(name: 'B')
  subscriber = Subscriber.find_by(name: 'bob')

  page.should_not have_selector(".relay_#{relay.id}.subscriber_#{subscriber.id}")
end
