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

Then(/^I should be required to enter my phone number$/) do
  expect(page).to have_text('your phone number')
end

When(/^I enter my phone number$/) do
  fill_in 'subscriber[number]', with: my_number
  click_button 'Save'
end

Then(/^I should see that relay (\d+) has been created$/) do |arg1|
  expect(page).to have_text('at the phone number 123')
end
