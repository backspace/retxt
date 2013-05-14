require_relative '../../app/commands/freeze'
require 'command_context'

describe Freeze do

  include_context 'command context'

  def execute
    Freeze.new(sender: sender, relay: relay, i18n: i18n, sends_txts: sends_txts).execute
  end

  context 'from a non-admin' do

    it 'does not freeze the relay' do
      relay.should_not_receive(:freeze!)
      execute
    end

    it 'replies with the non-admin message' do
      i18n.should_receive('t').with('txts.nonadmin').and_return('non-admin')
      sends_txts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'non-admin')
      execute
    end
  end

  context 'from an admin' do

    before do
      sender_is_admin
    end

    it 'freezes the relay' do
      relay.should_receive(:freeze!)
      execute
    end

    it 'replies with the freeze message' do
      i18n.should_receive('t').with('txts.freeze').and_return('freeze')
      sends_txts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'freeze')
      execute
    end
  end
end
