def my_number
  '2045551313'
end

Given(/^I am subscribed$/) do
  Subscriber.create(number: my_number)
end

Given(/^I am subscribed as '(.*?)'$/) do |nick|
  Subscriber.create(number: my_number, nick: nick)
end

Given(/^two other people are subscribed$/) do
  Subscriber.create(number: '5145551313')
  Subscriber.create(number: '4385551313')
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
