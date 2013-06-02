require_relative '../../app/commands/unvoice'
require_relative '../../app/commands/modify_subscription'
require 'command_context'

describe Unvoice do

  include_context 'command context'

  let(:arguments) { '@user' }

  def execute
    Unvoice.new(sender: sender, relay: relay, arguments: arguments).execute
  end

  it 'delegates to ModifySubscription' do
    I18n.should_receive('t').with('txts.unvoice', unvoicee_name: arguments).and_return('unvoice')
    modify_subscription = double('modify subscription')

    modifier = double('modifier')

    Unvoice.any_instance.stub(:modifier).and_return(modifier)

    ModifySubscription.should_receive(:new).with(sender: sender, relay: relay, arguments: arguments, modifier: modifier, success_message: 'unvoice').and_return(modify_subscription)
    modify_subscription.should_receive(:execute)

    execute
  end
end

