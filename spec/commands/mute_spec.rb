require_relative '../../app/commands/mute'
require_relative '../../app/commands/modify_subscription'
require 'command_context'

class SubscriptionModificationNotification; end

describe Mute do

  include_context 'command context'

  let(:arguments) { '@user' }

  def execute
    Mute.new(command_context).execute
  end

  it 'delegates to ModifySubscription' do
    modify_subscription = double('modify subscription')

    modifier = double('modifier')

    Mute.any_instance.stub(:modifier).and_return(modifier)

    SubscriptionModificationNotification.should_receive(:new).with(command_context, 'mute').and_return(notification = double)

    ModifySubscription.should_receive(:new).with(command_context, modifier: modifier, success_response: notification).and_return(modify_subscription)
    modify_subscription.should_receive(:execute)

    execute
  end
end
