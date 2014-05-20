require_relative '../../app/commands/unmute'
require_relative '../../app/commands/modify_subscription'
require 'command_context'

class SubscriptionModificationNotification; end

describe Unmute do

  include_context 'command context'

  let(:arguments) { '@user' }

  def execute
    Unmute.new(command_context).execute
  end

  it 'delegates to ModifySubscription' do
    modify_subscription = double('modify subscription')

    modifier = double('modifier')

    Unmute.any_instance.stub(:modifier).and_return(modifier)

    SubscriptionModificationNotification.should_receive(:new).with(command_context, 'unmute').and_return(notification = double)

    ModifySubscription.should_receive(:new).with(command_context, modifier: modifier, success_response: notification).and_return(modify_subscription)
    modify_subscription.should_receive(:execute)

    execute
  end
end
