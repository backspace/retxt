When(/^I view the message history for Alice$/) do
  visit subscribers_path
  click_link 'Alice'
end

Then(/^I should see that Alice sent '(.*)'$/) do |content|
  subscriber_id = Subscriber.find_by(name: 'Alice').id
  page.should have_selector(".txt.incoming[data-subscriber-id='#{subscriber_id}']", text: content)
end

Then(/^I should see that (.*) received '(.*)'$/) do |recipient_name, content|
  subscriber_id = Subscriber.find_by(name: recipient_name).id
  page.should have_selector(".txt.outgoing[data-subscriber-id='#{subscriber_id}']", text: content)
end

Then(/^I should see that Alice received a (confirmation|directconfirmation) txt$/) do |message_type|
  subscriber_id = Subscriber.find_by(name: 'Alice').id

  if message_type == 'confirmation'
    message = I18n.t('txts.relayed', subscriber_count: I18n.t('subscribers', count: Relay.first.subscriptions.count - 1))
  elsif message_type == 'directconfirmation'
    message = I18n.t('txts.direct.sent', target_name: '@Colleen')
  end

  page.should have_selector(".txt.outgoing[data-subscriber-id='#{subscriber_id}']", text: message)
end
