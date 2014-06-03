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

    allow_any_instance_of(Mute).to receive(:modifier).and_return(modifier)

    expect(SubscriptionModificationNotification).to receive(:new).with(command_context, 'mute').and_return(notification = double)

    expect(ModifySubscription).to receive(:new).with(command_context, modifier: modifier, success_response: notification).and_return(modify_subscription)
    expect(modify_subscription).to receive(:execute)

    execute
  end
end
