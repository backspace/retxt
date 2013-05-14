require_relative '../../app/commands/unmute'
require 'command_context'

describe Unmute do

  include_context 'command context'

  let(:arguments) { '@user' }
  let(:finds_subscribers) { double('finds_subscribers') }

  def execute
    Unmute.new(sender: sender, relay: relay, i18n: i18n, sends_txts: sends_txts, arguments: arguments, finds_subscribers: finds_subscribers).execute
  end

  context 'the sender is an admin' do

    before do
      sender_is_admin
    end

    context 'when the unmutee exists' do

      let(:unmutee) { double('mutee') }

      before do
        finds_subscribers.stub(:find).with(arguments).and_return(unmutee)
      end

      context 'and is subscribed' do
        let(:subscription) { double('subscription').as_null_object }

        before do
          relay.stub(:subscription_for).with(unmutee).and_return(subscription)
        end

        it 'unmutes the subscription' do
          subscription.should_receive(:unmute!)
          execute
        end

        it 'replies with the unmute message' do
          i18n.should_receive('t').with('txts.unmute', unmutee_name: arguments).and_return('unmute')
          sends_txts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'unmute')
          execute
        end
      end

      before do
        relay.stub(:subscription_for).with(unmutee).and_return(nil)
      end

      it 'replies with the unsubscribed target message' do
        i18n.should_receive('t').with('txts.unsubscribed_target', target: arguments).and_return('unsubscribed')
        sends_txts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'unsubscribed')
        execute
      end
    end

    before do
      finds_subscribers.stub(:find).with(arguments).and_return(nil)
    end

    it 'replies with the missing target message' do
      i18n.should_receive('t').with('txts.missing_target', target: arguments).and_return('missing')
      sends_txts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'missing')
      execute
    end
  end

  context 'from a non-admin' do
    it 'replies with the non-admin message' do
      i18n.should_receive('t').with('txts.nonadmin').and_return('non-admin')
      sends_txts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'non-admin')
      execute
    end
  end
end
