require_relative '../../app/commands/moderate'
require_relative '../../app/commands/modify_relay'
require 'command_context'

class RelayModificationNotification; end

describe Moderate do

  include_context 'command context'

  def execute
    Moderate.new(command_context).execute
  end

  it 'delegates to ModifyRelay' do
    modifier = double('modifier')
    expect(RelayModificationNotification).to receive(:new).with(command_context, 'moderate').and_return(notification = double)
    expect(ModifyRelay).to receive(:new).with(command_context, modifier: :moderate, success_response: notification).and_return(modifier)

    expect(modifier).to receive(:execute)

    execute
  end
end
