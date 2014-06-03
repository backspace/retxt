require_relative '../../app/commands/modify_relay'
require 'command_context'

describe ModifyRelay do

  include_context 'command context'

  let(:success_response) { double }
  let(:modifier) { :modify! }
  let(:arguments) { nil }

  def execute
    ModifyRelay.new(command_context, modifier: modifier, success_response: success_response).execute
  end

  context 'from an admin' do

    before do
      sender_is_admin
    end

    it 'modifies the relay and delivers the success response' do
      expect(relay).to receive(modifier)
      expect(success_response).to receive(:deliver).with(relay.admins)
      execute
    end

    context 'with arguments' do
      let(:arguments) { 'an argument' }

      it 'modifies the relay with the arguments and delivers the success response' do
        expect(relay).to receive(modifier).with(arguments)
        expect(success_response).to receive(:deliver).with(relay.admins)
        execute
      end
    end
  end

  context 'from a non-admin' do

    it 'does not modify the relay and replies with the non-admin response' do
      expect(relay).not_to receive(modifier)
      expect_response_to_sender 'NonAdminBounceResponse'
      expect_notification_of_admins 'NonAdminBounceNotification'
      execute
    end
  end
end
