require_relative '../../app/commands/help'
require 'command_context'

describe Help do
  include_context 'command context'

  def execute
    Help.new(sender: sender, relay: relay, i18n: i18n, sends_txts: sends_txts).execute
  end

  it 'replies with the help message' do
    relay.stub(:subscribers).and_return(double('subs', length: 3))

    i18n.stub(:t).with('subscribers', count: 2).and_return('2 subscribers')

    i18n.stub(:t).with('txts.help', subscriber_count: '2 subscribers').and_return('help')
    sends_txts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'help')

    execute
  end
end
