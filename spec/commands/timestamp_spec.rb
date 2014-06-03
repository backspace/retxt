require_relative '../../app/commands/timestamp'
require_relative '../../app/commands/modify_relay'
require 'command_context'

class TimestampModificationNotification; end

describe Timestamp do
  include_context 'command context'

  let(:arguments) { 'strftime' }

  def execute
    Timestamp.new(command_context).execute
  end

  it 'delegates to ModifyRelay' do
    modify_relay = double('modify relay')
    modifier = :timestamp!

    allow_any_instance_of(Timestamp).to receive(:modifier).and_return(modifier)

    expect(TimestampModificationNotification).to receive(:new).with(command_context).and_return(notification = double)
    expect(ModifyRelay).to receive(:new).with(command_context, modifier: modifier, success_response: notification).and_return(modify_relay)
    expect(modify_relay).to receive(:execute)

    execute
  end
end
