When(/^I view the message history for alice$/) do
  visit subscriber_txts_path(Subscriber.find_by(name: 'alice'))
end

Then(/^I should see that alice sent '(.*)'$/) do |content|
  subscriber_id = Subscriber.find_by(name: 'alice').id
  page.should have_selector(".txt.incoming[data-subscriber-id='#{subscriber_id}']", text: content)
end

Then(/^I should see that (.*) received '(.*)'$/) do |recipient_name, content|
  subscriber_id = Subscriber.find_by(name: recipient_name).id
  page.should have_selector(".txt.outgoing[data-subscriber-id='#{subscriber_id}']", text: content)
end

Then(/^I should see that alice received a (confirmation|directconfirmation) txt$/) do |message_type|
  subscriber_id = Subscriber.find_by(name: 'alice').id

  if message_type == 'confirmation'
    message = I18n.t('txts.relayed', subscriber_count: I18n.t('subscribers', count: Relay.first.subscriptions.count - 1))
  elsif message_type == 'directconfirmation'
    message = I18n.t('txts.direct.sent', target_name: '@colleen')
  end

  page.should have_selector(".txt.outgoing[data-subscriber-id='#{subscriber_id}']", text: message)
end
