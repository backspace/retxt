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

    Timestamp.any_instance.stub(:modifier).and_return(modifier)

    TimestampModificationNotification.should_receive(:new).with(command_context).and_return(notification = double)
    ModifyRelay.should_receive(:new).with(command_context, modifier: modifier, success_response: notification).and_return(modify_relay)
    modify_relay.should_receive(:execute)

    execute
  end
end
