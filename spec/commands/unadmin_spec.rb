require_relative '../../app/commands/unadmin'
require 'command_context'

describe Unadmin do
  include_context 'command context'

  let(:arguments) { '@user' }
  let(:finds_subscribers) { double('finds_subscribers') }

  before do
    stub_const('FindsSubscribers', finds_subscribers)
  end

  def execute
    Unadmin.new(command_context).execute
  end

  context 'the sender is an admin' do
    before do
      sender_is_admin
    end

    context 'when the unadminee exists' do
      let(:unadminee) { double('unadminee').as_null_object }

      before do
        finds_subscribers.stub(:find).with(arguments).and_return(unadminee)
      end

      it 'makes the unadminee an non-admin and notifies admins' do
        unadminee.should_receive(:unadmin!)
        expect_notification_of_admins 'UnadminificationNotification'
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
      execute
    end
  end
end

