require_relative '../../app/commands/unmoderate'
require_relative '../../app/commands/modify_relay'
require 'command_context'

describe Unmoderate do

  include_context 'command context'

  def execute
    Unmoderate.new(command_context).execute
  end

  it 'delegates to ModifyRelay' do
    I18n.should_receive('t').with('txts.admin.unmoderate', admin_name: sender.addressable_name).and_return('unmoderate')
    modifier = double('modifier')
    ModifyRelay.should_receive(:new).with(command_context, modifier: :unmoderate!, success_message: 'unmoderate').and_return(modifier)

    modifier.should_receive(:execute)

    execute
  end
end
