require_relative '../../app/commands/freeze'
require_relative '../../app/commands/modify_relay'
require 'command_context'

describe Freeze do

  include_context 'command context'

  def execute
    Freeze.new(command_context).execute
  end

  it 'delegates to ModifyRelay' do
    modifier = double('modifier')
    RelayModificationNotification.should_receive(:new).with(command_context, 'freeze').and_return(notification = double)
    ModifyRelay.should_receive(:new).with(command_context, modifier: :freeze, success_response: notification).and_return(modifier)

    modifier.should_receive(:execute)

    execute
  end
end
