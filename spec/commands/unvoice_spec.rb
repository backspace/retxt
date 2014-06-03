require_relative '../../app/commands/unvoice'
require_relative '../../app/commands/modify_subscription'
require 'command_context'

class SubscriptionModificationNotification; end

describe Unvoice do

  include_context 'command context'

  let(:arguments) { '@user' }

  def execute
    Unvoice.new(command_context).execute
  end

  it 'delegates to ModifySubscription' do
    modify_subscription = double('modify subscription')

    modifier = double('modifier')

    allow_any_instance_of(Unvoice).to receive(:modifier).and_return(modifier)

    expect(SubscriptionModificationNotification).to receive(:new).with(command_context, 'unvoice').and_return(notification = double)

    expect(ModifySubscription).to receive(:new).with(command_context, modifier: modifier, success_response: notification).and_return(modify_subscription)
    expect(modify_subscription).to receive(:execute)

    execute
  end
end

