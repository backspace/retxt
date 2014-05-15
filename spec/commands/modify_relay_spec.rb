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
      relay.should_receive(modifier)
      success_response.should_receive(:deliver).with(relay.admins)
      execute
    end

    context 'with arguments' do
      let(:arguments) { 'an argument' }

      it 'modifies the relay with the arguments and delivers the success response' do
        relay.should_receive(modifier).with(arguments)
        success_response.should_receive(:deliver).with(relay.admins)
        execute
      end
    end
  end

  context 'from a non-admin' do

    it 'does not modify the relay and replies with the non-admin response' do
      relay.should_not_receive(modifier)
      expect_response_to_sender 'NonAdminBounceResponse'
      execute
    end
  end
end
