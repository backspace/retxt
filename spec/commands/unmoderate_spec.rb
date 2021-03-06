require_relative '../../app/commands/unmoderate'
require_relative '../../app/commands/modify_relay'
require 'command_context'

class RelayModificationNotification; end

describe Unmoderate do

  include_context 'command context'

  def execute
    Unmoderate.new(command_context).execute
  end

  it 'delegates to ModifyRelay' do
    modifier = double('modifier')
    expect(RelayModificationNotification).to receive(:new).with(command_context, 'unmoderate').and_return(notification = double)
    expect(ModifyRelay).to receive(:new).with(command_context, modifier: :unmoderate, success_response: notification).and_return(modifier)

    expect(modifier).to receive(:execute)

    execute
  end
end
