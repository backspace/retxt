require_relative '../../app/commands/delete'
require 'command_context'
require 'txts_relay_admins'
require 'deletes_relays'

describe Delete do
  include_context 'command context'

  def execute
    Delete.new(command_context).execute
  end

  context 'from an admin' do
    before do
      sender_is_admin
    end

    it 'notifies admins and deletes the relay' do
      expect_notification_of_admins 'DeletionNotification'
      DeletesRelays.should_receive(:delete_relay).with(relay: relay)

      execute
    end
  end

  context 'from a non-admin' do
    it 'does not delete the relay and responds with the non-admin message' do
      relay.should_not_receive(:delete)
      expect_response_to_sender 'NonAdminResponse'
      execute
    end
  end
end
