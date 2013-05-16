require_relative '../../app/commands/relay_command'
require 'command_context'

class RelayedTxtFormatter; end

describe RelayCommand do

  include_context 'command context'
  let(:content) { 'preformatted text' }

  def execute
    RelayCommand.new(sender: sender, relay: relay, i18n: i18n, sends_txts: sends_txts, content: content).execute
  end

  context 'from a sender who is subscribed' do
    let(:other_subscriber) { double('other_subscriber', number: '11') }
    let(:subscribers) { [sender, other_subscriber] }
    let(:subscription) { double('subscription', muted: false) }

    let(:formatted_txt) { '@sender sez: the formatted result' }

    before do
      relay.stub(:subscribed?).with(sender).and_return(true)
      relay.stub(:subscribers).and_return(subscribers)
      relay.stub(:subscription_for).with(sender).and_return(subscription)

      RelayedTxtFormatter.stub(:new).and_return(double('formatter', format: formatted_txt))
    end

    it 'relays the message and notifies the sender' do
      sends_txts.should_receive(:send_txt).with(from: relay.number, to: other_subscriber.number, body: formatted_txt)

      i18n.should_receive('t').with('subscribers', count: subscribers.length - 1).and_return("1 subscriber")
      i18n.should_receive('t').with('txts.relayed', subscriber_count: "1 subscriber").and_return('relayed')

      sends_txts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'relayed')

      execute
    end

    context 'to a relay that is frozen' do
      before do
        relay.stub(:frozen).and_return(true)
      end

      it 'responds that the relay is frozen' do
        i18n.should_receive('t').with('txts.frozen').and_return('frozen')
        sends_txts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'frozen')

        execute
      end
    end

    context 'when the sender is muted' do
      before do
        subscription.stub(:muted).and_return(true)
      end

      it 'notifies admins and responds that the sender is muted' do
        admin = double('admin', number: 5)
        relay.stub(:admins).and_return([admin])

        i18n.should_receive('t').with('txts.muted_fail').and_return('muted fail')
        sends_txts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'muted fail')

        i18n.should_receive('t').with('txts.muted_report', mutee_name: sender.addressable_name, muted_message: content).and_return('muted report')
        sends_txts.should_receive(:send_txt).with(from: relay.number, to: admin.number, body: 'muted report')

        execute
      end
    end
  end

  context 'from a sender who is not subscribed' do

    before do
      relay.stub(:subscribed?).with(sender).and_return(false)
    end

    it 'responds that the sender is not subscribed' do
      i18n.should_receive('t').with('txts.not_subscribed').and_return('not subscribed')
      sends_txts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'not subscribed')

      execute
    end
  end
end
