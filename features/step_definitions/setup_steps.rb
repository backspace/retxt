When(/^I visit the site$/) do
  visit '/'
end

Then(/^I should be required to create an account$/) do
  expect(page).to have_text('Sign up')
end

When(/^I create an account$/) do
  fill_in 'Email', with: 'admin@example.com'
  fill_in 'user_password', with: 'abcdefghi'
  fill_in 'user_password_confirmation', with: 'abcdefghi'

  click_button 'Sign up'
end

Then(/^I should be required to enter my name and phone number$/) do
  expect(page).to have_text('your name and phone number')
end

When(/^I enter my name and phone number( ([^\s]*))?$/) do |number_given, number|
  fill_in 'subscriber[name]', with: 'alice'
  fill_in 'subscriber[number]', with: number || my_number
  click_button 'Save'
end

Then(/^I should see that my number is from( area code (\d+) in)? (\w*)/) do |area_code_given, area_code, country|
  @me = Subscriber.first

  expect(page).to have_text(country)
  expect(page).to have_text('514') if area_code_given
end

Then(/^I should be required to name the relay$/) do
  expect(page).to have_text('name for the relay')
end

When(/^I name the relay( and give it the number (\d+))?$/) do |number_given, number|
  fill_in 'relay[name]', with: 'arelay'
  fill_in 'relay[number]', with: number if number_given

  click_button 'Save'
end

Then(/^I should see that relay (\d+) has been created$/) do |number|
  expect(page).to have_text("at the phone number #{number}")
end
