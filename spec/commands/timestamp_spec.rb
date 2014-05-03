require_relative '../../app/commands/timestamp'
require_relative '../../app/commands/modify_relay'
require 'command_context'

describe Timestamp do
  include_context 'command context'

  let(:arguments) { 'strftime' }

  def execute
    Timestamp.new(command_context).execute
  end

  it 'delegates to ModifyRelay' do
    I18n.should_receive('t').with('txts.admin.timestamp', admin_name: sender.addressable_name, timestamp: arguments).and_return('timestamp')

    modify_relay = double('modify relay')
    modifier = :timestamp!

    Timestamp.any_instance.stub(:modifier).and_return(modifier)

    ModifyRelay.should_receive(:new).with(command_context, modifier: modifier, success_message: 'timestamp').and_return(modify_relay)
    modify_relay.should_receive(:execute)

    execute
  end
end
