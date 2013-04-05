Then(/^I should receive a txt saying my nick is '(.*?)'$/) do |nick|
  response_should_include(nick) && response_should_include('nick')
end
