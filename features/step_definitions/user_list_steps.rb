When(/^I visit the users list$/) do
  visit users_path
end

When(/^I make 'user@example\.com' an admin$/) do
  visit users_path

  user = User.find_by(email: 'user@example.com')

  page.find("#user_#{user.id}").check("admin")
end

Then(/^I should see that '(.*)' is registered$/) do |address|
  user = User.find_by(email: address)

  page.should have_css("#user_#{user.id}")
end

Then(/^I should see that 'user@example\.com' is an admin$/) do
  user = User.find_by(email: 'user@example.com')

  page.find("#user_#{user.id} .admin").should be_checked
end
