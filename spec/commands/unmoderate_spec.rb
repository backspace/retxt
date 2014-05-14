require_relative '../../app/commands/unmoderate'
require_relative '../../app/commands/modify_relay'
require 'command_context'

describe Unmoderate do

  include_context 'command context'

  def execute
    Unmoderate.new(command_context).execute
  end

  it 'delegates to ModifyRelay' do
    modifier = double('modifier')
    RelayModificationNotification.should_receive(:new).with(command_context, 'admin.unmoderate').and_return(notification = double)
    ModifyRelay.should_receive(:new).with(command_context, modifier: :unmoderate, success_response: notification).and_return(modifier)

    modifier.should_receive(:execute)

    execute
  end
end
