require_relative '../../app/commands/unmute'
require_relative '../../app/commands/modify_subscription'
require 'command_context'

describe Unmute do

  include_context 'command context'

  let(:arguments) { '@user' }

  def execute
    Unmute.new(command_context).execute
  end

  it 'delegates to ModifySubscription' do
    I18n.should_receive('t').with('txts.unmute', unmutee_name: arguments, admin_name: sender.addressable_name).and_return('unmute')
    modify_subscription = double('modify subscription')

    modifier = double('modifier')

    Unmute.any_instance.stub(:modifier).and_return(modifier)

    ModifySubscription.should_receive(:new).with(command_context, modifier: modifier, success_message: 'unmute').and_return(modify_subscription)
    modify_subscription.should_receive(:execute)

    execute
  end
end
