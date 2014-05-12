require_relative '../../app/commands/moderate'
require_relative '../../app/commands/modify_relay'
require 'command_context'

describe Moderate do

  include_context 'command context'

  def execute
    Moderate.new(command_context).execute
  end

  it 'delegates to ModifyRelay' do
    I18n.should_receive('t').with('txts.admin.moderate', admin_name: sender.addressable_name).and_return('moderate')
    modifier = double('modifier')
    ModifyRelay.should_receive(:new).with(command_context, modifier: :moderate, success_message: 'moderate').and_return(modifier)

    modifier.should_receive(:execute)

    execute
  end
end
