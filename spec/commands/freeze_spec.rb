require_relative '../../app/commands/freeze'
require_relative '../../app/commands/modify_relay'
require 'command_context'

describe Freeze do

  include_context 'command context'

  def execute
    Freeze.new(command_context).execute
  end

  it 'delegates to ModifyRelay' do
    I18n.should_receive('t').with('txts.freeze', admin_name: sender.addressable_name).and_return('freeze')
    modifier = double('modifier')
    ModifyRelay.should_receive(:new).with(command_context, modifier: :freeze!, success_message: 'freeze').and_return(modifier)

    modifier.should_receive(:execute)

    execute
  end
end
