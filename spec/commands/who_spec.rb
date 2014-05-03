require_relative '../../app/commands/who'
require 'command_context'

describe Who do
  include_context 'command context'

  let(:who_txt) { double('who_txt') }
  let(:who_txt_content) { ['a who!', 'another who'] }

  def execute
    Who.new(command_context, who_txt: who_txt).execute
  end

  context 'from an admin' do
    before do
      sender_is_admin
    end

    it 'replies with the who txt' do
      who_txt.should_receive(:generate).with(relay: relay).and_return(who_txt_content)
      SendsTxts.should_receive(:send_txts).with(from: relay.number, to: sender.number, body: who_txt_content)
      execute
    end
  end
end
