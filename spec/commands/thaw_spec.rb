require_relative '../../app/commands/thaw'
require_relative '../../app/commands/modify_relay'
require 'command_context'

class RelayModificationNotification; end

describe Thaw do

  include_context 'command context'

  def execute
    Thaw.new(command_context).execute
  end

  it 'delegates to ModifyRelay' do
    modifier = double('modifier')
    expect(RelayModificationNotification).to receive(:new).with(command_context, 'thaw').and_return(notification = double)
    expect(ModifyRelay).to receive(:new).with(command_context, modifier: :thaw, success_response: notification).and_return(modifier)

    expect(modifier).to receive(:execute)

    execute
  end
end
