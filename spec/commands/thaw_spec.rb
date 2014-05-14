require_relative '../../app/commands/thaw'
require 'command_context'

describe Thaw do

  include_context 'command context'

  def execute
    Thaw.new(command_context).execute
  end

  it 'delegates to ModifyRelay' do
    modifier = double('modifier')
    RelayModificationNotification.should_receive(:new).with(command_context, 'thaw').and_return(notification = double)
    ModifyRelay.should_receive(:new).with(command_context, modifier: :thaw, success_response: notification).and_return(modifier)

    modifier.should_receive(:execute)

    execute
  end
end
