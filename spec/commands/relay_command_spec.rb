require_relative '../../app/commands/relay_command'
require 'command_context'

class RelayedTxtFormatter; end

describe RelayCommand do

  include_context 'command context'
  let(:txt) { double(:txt, body: content) }
  let(:content) { 'preformatted text' }

  def execute
    RelayCommand.new(sender: sender, relay: relay, txt: txt).execute
  end

  context 'from a sender who is subscribed' do
    let(:other_subscriber) { double('other_subscriber', number: '11') }
    let(:subscribers) { [sender, other_subscriber] }
    let(:subscription) { double('subscription', muted: false, voiced: false) }

    let(:formatted_txt) { '@sender sez: the formatted result' }

    before do
      relay.stub(:subscribed?).with(sender).and_return(true)
      relay.stub(:subscribers).and_return(subscribers)
      relay.stub(:subscription_for).with(sender).and_return(subscription)

      RelayedTxtFormatter.stub(:new).and_return(double('formatter', format: formatted_txt))
    end

    it 'relays the message and notifies the sender' do
      SendsTxts.should_receive(:send_txt).with(from: relay.number, to: other_subscriber.number, body: formatted_txt)

      I18n.should_receive('t').with('subscribers', count: subscribers.length - 1).and_return("1 subscriber")
      I18n.should_receive('t').with('txts.relayed', subscriber_count: "1 subscriber").and_return('relayed')

      SendsTxts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'relayed')

      execute
    end

    context 'and anonymous' do
      before do
        sender.stub(:anonymous?).and_return(true)
      end

      it 'relays the message, notifies the sender, and identifies the anon to admins' do
        SendsTxts.should_receive(:send_txt).with(from: relay.number, to: other_subscriber.number, body: formatted_txt)

        I18n.should_receive('t').with('subscribers', count: subscribers.length - 1).and_return("1 subscriber")
        I18n.should_receive('t').with('txts.relayed', subscriber_count: "1 subscriber").and_return('relayed')

        SendsTxts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'relayed')

        I18n.should_receive('t').with('txts.relay_identifier', absolute_name: sender.absolute_name, beginning: content[0..10]).and_return('identifier')

        TxtsRelayAdmins.should_receive(:txt_relay_admins).with(relay: relay, body: 'identifier')

        execute
      end
    end

    context 'to a relay that is frozen' do
      before do
        relay.stub(:frozen).and_return(true)
      end

      it 'responds that the relay is frozen' do
        I18n.should_receive('t').with('txts.frozen').and_return('frozen')
        SendsTxts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'frozen')

        execute
      end
    end

    context 'to a relay that is moderated' do
      before do
        relay.stub(:moderated).and_return(true)
      end

      it 'responds that the relay is moderated and notifies admins' do
        I18n.should_receive('t').with('txts.moderated_fail').and_return('moderated fail')
        SendsTxts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'moderated fail')

        I18n.should_receive('t').with('txts.moderated_report', subscriber_name: sender.absolute_name, moderated_message: content).and_return('moderated report')
        TxtsRelayAdmins.should_receive(:txt_relay_admins).with(relay: relay, body: 'moderated report')

        execute
      end

      context 'from a subscriber that is an admin' do
        before do
          sender.stub(:admin).and_return(true)
        end

        it 'relays the message' do
          SendsTxts.should_receive(:send_txt).with(from: relay.number, to: other_subscriber.number, body: formatted_txt)

          I18n.should_receive('t').with('subscribers', count: subscribers.length - 1).and_return("1 subscriber")
          I18n.should_receive('t').with('txts.relayed', subscriber_count: "1 subscriber").and_return('relayed')

          SendsTxts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'relayed')

          execute
        end
      end

      context 'from a sender who is voiced' do
        before do
          subscription.stub(:voiced).and_return(true)
        end

        it 'relays the message' do
          SendsTxts.should_receive(:send_txt).with(from: relay.number, to: other_subscriber.number, body: formatted_txt)

          I18n.should_receive('t').with('subscribers', count: subscribers.length - 1).and_return("1 subscriber")
          I18n.should_receive('t').with('txts.relayed', subscriber_count: "1 subscriber").and_return('relayed')

          SendsTxts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'relayed')

          execute
        end
      end
    end

    context 'when the sender is muted' do
      before do
        subscription.stub(:muted).and_return(true)
      end

      it 'notifies admins and responds that the sender is muted' do
        admin = double('admin', number: 5)
        relay.stub(:admins).and_return([admin])

        I18n.should_receive('t').with('txts.muted_fail').and_return('muted fail')
        SendsTxts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'muted fail')

        I18n.should_receive('t').with('txts.muted_report', mutee_name: sender.addressable_name, muted_message: content).and_return('muted report')
        SendsTxts.should_receive(:send_txt).with(from: relay.number, to: admin.number, body: 'muted report')

        execute
      end
    end
  end

  context 'from a sender who is not subscribed' do

    before do
      relay.stub(:subscribed?).with(sender).and_return(false)
    end

    it 'responds that the sender is not subscribed' do
      I18n.should_receive('t').with('txts.not_subscribed').and_return('not subscribed')
      SendsTxts.should_receive(:send_txt).with(from: relay.number, to: sender.number, body: 'not subscribed')

      execute
    end
  end
end
