require_relative '../../app/commands/admin'
require 'command_context'

describe Admin do
  include_context 'command context'

  let(:arguments) { '@user' }
  let(:finds_subscribers) { double('finds_subscribers') }

  before do
    stub_const('FindsSubscribers', finds_subscribers)
  end

  def execute
    Admin.new(command_context).execute
  end

  context 'the sender is an admin' do
    before do
      sender_is_admin
    end

    context 'when the adminee exists' do
      let(:adminee) { double('adminee').as_null_object }

      before do
        finds_subscribers.stub(:find).with(arguments).and_return(adminee)
      end

      it 'makes the adminee an admin and notifies admins' do
        adminee.should_receive(:admin!)
        expect_notification_of_admins 'AdminificationNotification'
        execute
      end
    end

    before do
      finds_subscribers.stub(:find).with(arguments).and_return(nil)
    end

    it 'repiles with the missing target message' do
      expect_response_to_sender 'MissingTargetBounceResponse'
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
