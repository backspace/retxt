require_relative '../../app/commands/unknown'
require 'command_context'

describe Unknown do
  include_context 'command context'

  def execute
    Unknown.new(sender: sender, relay: relay, i18n: i18n, sends_txts: sends_txts).execute
  end

  it 'replies with the rename message' do
    i18n.stub('t').with('txts.unknown').and_return('unknown')
    sends_txts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'unknown')
    execute
  end
end
