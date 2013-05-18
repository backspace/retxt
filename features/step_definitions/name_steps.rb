Then(/^I should receive a txt saying my name is '(.*?)'$/) do |name|
  response_should_include I18n.t('txts.name', name: name)
end

Then(/^I should receive a welcome txt saying my name is '(.*?)'$/) do |name|
  response_should_include I18n.t('txts.welcome')
end
