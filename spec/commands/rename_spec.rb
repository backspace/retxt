require_relative '../../app/commands/rename'
require 'command_context'

describe Rename do

  include_context 'command context'

  let(:arguments) { 'newname' }

  def execute
    Rename.new(command_context).execute
  end

  context 'from an admin' do

    before do
      sender_is_admin
    end

    it 'renames the relay and responds' do
      relay.should_receive(:rename).with(arguments)
      expect_notification_of_admins 'RenameNotification'
      execute
    end
  end

  context 'from a non-admin' do
    it 'does not rename the relay and bounces' do
      relay.should_not_receive(:rename)
      expect_response_to_sender 'NonAdminBounceResponse'
      expect_notification_of_admins 'NonAdminBounceNotification'
      execute
    end
  end
end
