require_relative '../../app/commands/modify_relay'
require 'command_context'

describe ModifyRelay do

  include_context 'command context'

  let(:success_message) { 'success!' }
  let(:modifier) { :modify! }
  let(:arguments) { nil }

  def execute
    ModifyRelay.new(command_context, modifier: modifier, success_message: success_message).execute
  end

  context 'from an admin' do

    before do
      sender_is_admin
    end

    it 'modifies the relay' do
      relay.should_receive(modifier)
      execute
    end

    it 'replies with the success message' do
      TxtsRelayAdmins.should_receive(:txt_relay_admins).with(relay: relay, body: success_message)
      execute
    end

    context 'with arguments' do
      let(:arguments) { 'an argument' }

      it 'modifies the relay with the arguments' do
        relay.should_receive(modifier).with(arguments)
        execute
      end
    end
  end

  context 'from a non-admin' do

    it 'does not modify the relay' do
      relay.should_not_receive(modifier)
      execute
    end

    it 'replies with the non-admin message' do
      I18n.should_receive('t').with('txts.nonadmin').and_return('non-admin')
      SendsTxts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'non-admin')
      execute
    end
  end
end
