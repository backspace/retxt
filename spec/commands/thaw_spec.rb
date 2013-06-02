require_relative '../../app/commands/thaw'
require 'command_context'

describe Thaw do

  include_context 'command context'

  def execute
    Thaw.new(sender: sender, relay: relay).execute
  end

  it 'delegates to ModifyRelay' do
    I18n.should_receive('t').with('txts.thaw').and_return('thaw')
    modifier = double('modifier')
    ModifyRelay.should_receive(:new).with(sender: sender, relay: relay, modifier: :thaw!, success_message: 'thaw').and_return(modifier)

    modifier.should_receive(:execute)

    execute
  end
end
