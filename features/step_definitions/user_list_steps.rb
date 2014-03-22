When(/^I visit the users list$/) do
  visit users_path
end

Then(/^I should see that '(.*)' is registered$/) do |address|
  user = User.find_by(email: address)

  page.should have_css("#user_#{user.id}")
end
