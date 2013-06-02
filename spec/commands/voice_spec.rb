require_relative '../../app/commands/voice'
require 'command_context'

describe Voice do

  include_context 'command context'

  let(:arguments) { '@user' }
  let(:finds_subscribers) { double('finds_subscribers') }

  def execute
    Voice.new(sender: sender, relay: relay, arguments: arguments, finds_subscribers: finds_subscribers).execute
  end

  context 'the sender is an admin' do

    before do
      sender_is_admin
    end

    context 'when the voicee exists' do

      let(:voicee) { double('voicee') }

      before do
        finds_subscribers.stub(:find).with(arguments).and_return(voicee)
      end

      context 'and is subscribed' do
        let(:subscription) { double('subscription').as_null_object }

        before do
          relay.stub(:subscription_for).with(voicee).and_return(subscription)
        end

        it 'voices the subscription' do
          subscription.should_receive(:voice!)
          execute
        end

        it 'replies with the voice message' do
          I18n.should_receive('t').with('txts.voice', voicee_name: arguments).and_return('voice')
          SendsTxts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'voice')
          execute
        end
      end

      before do
        relay.stub(:subscription_for).with(voicee).and_return(nil)
      end

      it 'replies with the unsubscribed target message' do
        I18n.should_receive('t').with('txts.unsubscribed_target', target: arguments).and_return('unsubscribed')
        SendsTxts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'unsubscribed')
        execute
      end
    end

    before do
      finds_subscribers.stub(:find).with(arguments).and_return(nil)
    end

    it 'replies with the missing target message' do
      I18n.should_receive('t').with('txts.missing_target', target: arguments).and_return('missing')
      SendsTxts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'missing')
      execute
    end
  end

  context 'from a non-admin' do
    it 'replies with the non-admin message' do
      I18n.should_receive('t').with('txts.nonadmin').and_return('non-admin')
      SendsTxts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'non-admin')
      execute
    end
  end
end
