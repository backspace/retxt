Then(/^I should receive a txt saying my name is '(.*?)'$/) do |name|
  response_should_include(name) && response_should_include('name')
end

Then(/^I should receive a welcome txt saying my name is '(.*?)'$/) do |name|
  response_should_include 'welcome'
  step("I should receive a txt saying my name is '#{name}'")
end
