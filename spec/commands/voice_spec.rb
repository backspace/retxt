require_relative '../../app/commands/voice'
require_relative '../../app/commands/modify_subscription'
require 'command_context'

describe Voice do

  include_context 'command context'

  let(:arguments) { '@user' }

  def execute
    Voice.new(sender: sender, relay: relay, arguments: arguments).execute
  end

  it 'delegates to ModifySubscription' do
    I18n.should_receive('t').with('txts.voice', voicee_name: arguments, admin_name: sender.addressable_name).and_return('voice')
    modify_subscription = double('modify subscription')

    modifier = double('modifier')

    Voice.any_instance.stub(:modifier).and_return(modifier)

    ModifySubscription.should_receive(:new).with(sender: sender, relay: relay, arguments: arguments, modifier: modifier, success_message: 'voice').and_return(modify_subscription)
    modify_subscription.should_receive(:execute)

    execute
  end
end

