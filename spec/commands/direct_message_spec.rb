require_relative '../../app/commands/direct_message'
require 'command_context'
require 'finds_subscribers'
require 'timestamp_formatter'

describe DirectMessage do
  include_context 'command context'

  let(:txt) { double(:txt, body: content) }
  let(:content) { '@user hello' }

  def execute
    DirectMessage.new(sender: sender, relay: relay, txt: txt).execute
  end

  context 'when the sender exists' do
    before do
      relay.stub(:subscribed?).with(sender).and_return(true)
    end

    context 'and is not anonymous' do
      before do
        sender.stub(:anonymous?).and_return(false)
        sender.stub(:addressable_name).and_return("@sender")
      end

      context 'and the target exists' do
        let(:target) { double('target', number: '5555') }
        let(:timestamp) { double(:formatter, format: 'timestamp ') }

        before do
          FindsSubscribers.stub(:find).with('@user').and_return(target)
          TimestampFormatter.should_receive(:new).with(relay: relay, txt: txt).and_return(timestamp)
        end

        it 'sends the message and replies' do
          I18n.stub(:t).with('txts.direct.outgoing', prefix: timestamp.format, sender: sender.addressable_name, message: content).and_return('outgoing')
          SendsTxts.should_receive(:send_txt).with(from: relay.number, to: target.number, body: 'outgoing')

          I18n.stub(:t).with('txts.direct.sent', target_name: '@user').and_return('sent')
          SendsTxts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'sent')

          execute
        end
      end

      context 'and the target does not exist' do
        before do
          FindsSubscribers.stub(:find).with('@user').and_return(nil)
        end

        it 'sends the failed message' do
          I18n.stub(:t).with('txts.direct.missing_target', target_name: '@user').and_return('failed')
          SendsTxts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'failed')

          execute
        end
      end
    end

    context 'and is anonymous' do
      before do
        sender.stub(:anonymous?).and_return(true)
      end

      it 'forbids the message' do
        I18n.stub(:t).with('txts.direct.anonymous').and_return('forbidden')
        SendsTxts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'forbidden')

        execute
      end
    end
  end
end
