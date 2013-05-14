Given(/^the relay is frozen$/) do
  Relay.first.update_attribute(:frozen, true)
end
