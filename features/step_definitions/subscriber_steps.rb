def my_number
  '2045551313'
end

Given(/^I am subscribed$/) do
  Subscriber.create(number: my_number)
end

Given(/^two other people are subscribed$/) do
  Subscriber.create(number: '5145551313')
  Subscriber.create(number: '4385551313')
end

When(/^I visit the subscribers list$/) do
  visit subscribers_path
end

Then(/^I should( not)? see myself$/) do |negation|
  page.send(negation ? :should_not : :should, have_content(my_number))
end
