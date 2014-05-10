When(/^I visit the users list$/) do
  visit users_path
end

When(/^I make 'user@example\.com' an admin$/) do
  visit users_path

  user = User.find_by(email: 'user@example.com')

  page.find("#user_#{user.id}").check("admin")
  wait_for_ajax
end

Then(/^I should see that '(.*)' is registered$/) do |address|
  user = User.find_by(email: address)

  page.should have_css("#user_#{user.id}")
end

Then(/^I should see that '(.*)' is a site admin$/) do |address|
  user = User.find_by(email: address)

  page.find("#user_#{user.id} .admin").should be_checked
end
