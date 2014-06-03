require_relative '../../app/commands/clear'
require 'command_context'

describe Clear do
  include_context 'command context'

  def execute
    Clear.new(command_context).execute
  end

  context 'from an admin' do
    before do
      sender_is_admin
    end

    it 'clears the relay' do
      nonadmin = double('nonadmin')
      allow(relay).to receive(:non_admins).and_return([nonadmin])

      subscription = double('subscription')
      allow(relay).to receive(:subscription_for).with(nonadmin).and_return(subscription)

      expect(subscription).to receive(:destroy)

      expect_notification_of_admins 'ClearNotification'

      execute
    end
  end

  context 'from a non-admin' do
    it 'replies with the non-admin message' do
      expect_response_to_sender 'NonAdminBounceResponse'
      expect_notification_of_admins 'NonAdminBounceNotification'
      execute
    end
  end
end
