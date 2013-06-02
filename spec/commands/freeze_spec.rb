require_relative '../../app/commands/freeze'
require_relative '../../app/commands/modify_relay'
require 'command_context'

describe Freeze do

  include_context 'command context'

  def execute
    Freeze.new(sender: sender, relay: relay).execute
  end

  it 'delegates to ModifyRelay' do
    I18n.should_receive('t').with('txts.freeze').and_return('freeze')
    modifier = double('modifier')
    ModifyRelay.should_receive(:new).with(sender: sender, relay: relay, modifier: :freeze!, success_message: 'freeze').and_return(modifier)

    modifier.should_receive(:execute)

    execute
  end
end
