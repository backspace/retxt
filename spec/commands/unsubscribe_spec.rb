require_relative '../../app/commands/unsubscribe'
require 'command_context'

describe Unsubscribe do
  include_context 'command context'

  let(:subscriptionRepository) { double('subscription repository') }

  def execute
    Unsubscribe.new(command_context).execute
  end

  context 'when the sender is subscribed' do
    before do
      allow(relay).to receive(:subscribed?).with(sender).and_return(true)
    end

    it 'deletes the subscription and notifies admins' do
      subscription = double('subscription')
      allow(relay).to receive(:subscription_for).with(sender).and_return(subscription)

      expect(subscription).to receive(:destroy)

      expect_response_to_sender 'UnsubscribeResponse'
      expect_notification_of_admins 'UnsubscriptionNotification'
      execute
    end
  end

  context 'when the sender is not subscribed' do
    before do
      allow(relay).to receive(:subscribed?).with(sender).and_return(false)
    end

    it 'sends the not subscribed message' do
      expect_response_to_sender 'NotSubscribedUnsubscribeBounceResponse'
      expect_notification_of_admins 'NotSubscribedUnsubscribeBounceNotification'
      execute
    end
  end
end
