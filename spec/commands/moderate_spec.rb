require_relative '../../app/commands/moderate'
require_relative '../../app/commands/modify_relay'
require 'command_context'

describe Moderate do

  include_context 'command context'

  def execute
    Moderate.new(command_context).execute
  end

  it 'delegates to ModifyRelay' do
    modifier = double('modifier')
    RelayModificationNotification.should_receive(:new).with(command_context, 'admin.moderate').and_return(notification = double)
    ModifyRelay.should_receive(:new).with(command_context, modifier: :moderate, success_response: notification).and_return(modifier)

    modifier.should_receive(:execute)

    execute
  end
end
