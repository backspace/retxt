Then(/^I should receive a txt saying my nick is '(.*?)'$/) do |nick|
  response_should_include(nick) && response_should_include('nick')
end

Then(/^I should receive a welcome txt saying my nick is 'morrison'$/) do
  response_should_include 'welcome'
  step("I should receive a txt saying my nick is 'morrison'")
end
