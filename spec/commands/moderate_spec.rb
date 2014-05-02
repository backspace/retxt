require_relative '../../app/commands/moderate'
require_relative '../../app/commands/modify_relay'
require 'command_context'

describe Moderate do

  include_context 'command context'

  def execute
    Moderate.new(sender: sender, relay: relay).execute
  end

  it 'delegates to ModifyRelay' do
    I18n.should_receive('t').with('txts.admin.moderate', admin_name: sender.addressable_name).and_return('moderate')
    modifier = double('modifier')
    ModifyRelay.should_receive(:new).with(sender: sender, relay: relay, modifier: :moderate!, success_message: 'moderate').and_return(modifier)

    modifier.should_receive(:execute)

    execute
  end
end
