require_relative '../../app/commands/help'
require 'command_context'

describe Help do
  include_context 'command context'

  def execute
    Help.new(command_context).execute
  end

  it 'replies with the help message' do
    relay.stub(:subscribers).and_return(double('subs', length: 3))

    I18n.stub(:t).with('subscribers', count: 2).and_return('2 subscribers')

    I18n.stub(:t).with('txts.help', subscriber_count: '2 subscribers').and_return('help')
    SendsTxts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'help')

    execute
  end
end
