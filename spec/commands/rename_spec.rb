require_relative '../../app/commands/rename'
require 'command_context'

describe Rename do

  include_context 'command context'

  let(:arguments) { 'newname' }

  def execute
    Rename.new(sender: sender, relay: relay, arguments: arguments).execute
  end

  context 'from an admin' do

    before do
      sender_is_admin
    end

    it 'renames the relay' do
      relay.should_receive(:rename!).with(arguments)
      execute
    end

    it 'replies with the rename message' do
      I18n.should_receive('t').with('txts.rename', relay_name: arguments).and_return('rename')
      SendsTxts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'rename')
      execute
    end
  end

  context 'from a non-admin' do
    it 'does not rename the relay' do
      relay.should_not_receive(:rename!)
      execute
    end

    it 'replies with the non-admin message' do
      I18n.should_receive('t').with('txts.nonadmin').and_return('non-admin')
      SendsTxts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'non-admin')
      execute
    end
  end
end
