require_relative '../../app/commands/unvoice'
require 'command_context'

describe Unvoice do

  include_context 'command context'

  let(:arguments) { '@user' }
  let(:finds_subscribers) { double('finds_subscribers') }

  def execute
    Unvoice.new(sender: sender, relay: relay, arguments: arguments, finds_subscribers: finds_subscribers).execute
  end

  context 'the sender is an admin' do

    before do
      sender_is_admin
    end

    context 'when the unvoicee exists' do

      let(:unvoicee) { double('unvoicee') }

      before do
        finds_subscribers.stub(:find).with(arguments).and_return(unvoicee)
      end

      context 'and is subscribed' do
        let(:subscription) { double('subscription').as_null_object }

        before do
          relay.stub(:subscription_for).with(unvoicee).and_return(subscription)
        end

        it 'unvoices the subscription' do
          subscription.should_receive(:unvoice!)
          execute
        end

        it 'replies with the unvoice message' do
          I18n.should_receive('t').with('txts.unvoice', unvoicee_name: arguments).and_return('unvoice')
          SendsTxts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'unvoice')
          execute
        end
      end

      before do
        relay.stub(:subscription_for).with(unvoicee).and_return(nil)
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
