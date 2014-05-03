require_relative '../../app/commands/mute'
require_relative '../../app/commands/modify_subscription'
require 'command_context'

describe Mute do

  include_context 'command context'

  let(:arguments) { '@user' }

  def execute
    Mute.new(command_context).execute
  end

  it 'delegates to ModifySubscription' do
    I18n.should_receive('t').with('txts.mute', mutee_name: arguments, admin_name: sender.addressable_name).and_return('mute')
    modify_subscription = double('modify subscription')

    modifier = double('modifier')

    Mute.any_instance.stub(:modifier).and_return(modifier)

    ModifySubscription.should_receive(:new).with(command_context, modifier: modifier, success_message: 'mute').and_return(modify_subscription)
    modify_subscription.should_receive(:execute)

    execute
  end
end
