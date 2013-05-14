require_relative '../../app/commands/modify_relay'
require 'command_context'

describe ModifyRelay do

  include_context 'command context'

  let(:success_message) { 'success!' }
  let(:modifier) { :modify! }

  def execute
    ModifyRelay.new(sender: sender, relay: relay, i18n: i18n, sends_txts: sends_txts, modifier: modifier, success_message: success_message).execute
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
      sends_txts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: success_message)
      execute
    end
  end

  context 'from a non-admin' do

    it 'does not modify the relay' do
      relay.should_not_receive(modifier)
      execute
    end

    it 'replies with the non-admin message' do
      i18n.should_receive('t').with('txts.nonadmin').and_return('non-admin')
      sends_txts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'non-admin')
      execute
    end
  end
end
