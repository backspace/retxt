def my_number
  '2045551313'
end

When(/^I visit the subscribers list$/) do
  visit subscribers_path
end

Then(/^I should see myself$/) do
  page.should have_content(my_number)
end
