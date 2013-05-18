require_relative '../../app/commands/name'
require 'command_context'

describe Name do
  include_context 'command context'
  let(:arguments) { 'newname' }

  def execute
    Name.new(sender: sender, relay: relay, i18n: i18n, sends_txts: sends_txts, arguments: arguments).execute
  end

  context 'when the sender is subscribed' do
    before do
      relay.stub(:subscribed?).with(sender).and_return(true)
    end

    it 'changes the sender name and sends a confirmation' do
      ChangesNames.should_receive(:change_name).with(sender, arguments)
      sender.should_receive(:name_or_anon).and_return(arguments)
      i18n.should_receive('t').with('txts.name', name: arguments).and_return('name')
      sends_txts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'name')

      execute
    end
  end
end
