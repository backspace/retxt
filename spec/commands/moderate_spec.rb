require_relative '../../app/commands/moderate'
require_relative '../../app/commands/modify_relay'
require 'command_context'

describe Moderate do

  include_context 'command context'

  def execute
    Moderate.new(sender: sender, relay: relay).execute
  end

  context 'from a non-admin' do

    it 'does not moderate the relay' do
      relay.should_not_receive(:moderate!)
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

    it 'moderates the relay' do
      relay.should_receive(:moderate!)
      execute
    end

    it 'replies with the moderate message' do
      I18n.should_receive('t').with('txts.admin.moderate').and_return('moderate')
      SendsTxts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'moderate')
      execute
    end
  end
end
