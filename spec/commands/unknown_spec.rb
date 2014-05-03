require_relative '../../app/commands/unknown'
require 'command_context'

describe Unknown do
  include_context 'command context'

  def execute
    Unknown.new(command_context).execute
  end

  it 'replies with the rename message' do
    I18n.stub('t').with('txts.unknown').and_return('unknown')
    SendsTxts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'unknown', originating_txt_id: command_context.originating_txt_id)
    execute
  end
end
