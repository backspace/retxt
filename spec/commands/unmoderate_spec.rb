require_relative '../../app/commands/unmoderate'
require_relative '../../app/commands/modify_relay'
require 'command_context'

describe Unmoderate do

  include_context 'command context'

  def execute
    Unmoderate.new(sender: sender, relay: relay).execute
  end

  context 'from a non-admin' do

    it 'does not unmoderate the relay' do
      relay.should_not_receive(:unmoderate!)
      execute
    end

    it 'replies with the non-admin message' do
      I18n.should_receive('t').with('txts.nonadmin').and_return('non-admin')
      SendsTxts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'non-admin')
      execute
    end
  end

  context 'from an admin' do

    before do
      sender_is_admin
    end

    it 'unmoderates the relay' do
      relay.should_receive(:unmoderate!)
      execute
    end

    it 'replies with the unmoderate message' do
      I18n.should_receive('t').with('txts.admin.unmoderate').and_return('unmoderate')
      SendsTxts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'unmoderate')
      execute
    end
  end
end
