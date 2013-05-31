require_relative '../../app/commands/thaw'
require 'command_context'

describe Thaw do

  include_context 'command context'

  def execute
    Thaw.new(sender: sender, relay: relay).execute
  end

  context 'from an admin' do

    before do
      sender_is_admin
    end

    it 'thaws the relay' do
      relay.should_receive(:thaw!)
      execute
    end

    it 'replies with the thaw message' do
      I18n.should_receive('t').with('txts.thaw').and_return('thaw')
      SendsTxts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'thaw')
      execute
    end
  end

  context 'from a non-admin' do

     it 'does not thaw the relay' do
       relay.should_not_receive(:thaw!)
       execute
     end

     it 'replies with the non-admin message' do
       I18n.should_receive('t').with('txts.nonadmin').and_return('non-admin')
       SendsTxts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'non-admin')
       execute
     end
  end
end
