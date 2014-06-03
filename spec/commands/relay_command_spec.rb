require_relative '../../app/commands/relay_command'
require 'command_context'

class RelayedTxtFormatter; end

describe RelayCommand do

  include_context 'command context'
  let(:txt) { double(:txt, body: content, id: 'def') }
  let(:content) { 'preformatted text' }

  def execute
    RelayCommand.new(command_context).execute
  end

  context 'from a sender who is subscribed' do
    let(:other_subscriber) { double('other_subscriber', number: '11') }
    let(:subscribers) { [sender, other_subscriber] }
    let(:subscription) { double('subscription', muted: false, voiced: false) }

    let(:formatted_txt) { '@sender sez: the formatted result' }

    before do
      allow(relay).to receive(:subscribed?).with(sender).and_return(true)
      allow(relay).to receive(:subscribers).and_return(subscribers)
      allow(relay).to receive(:subscription_for).with(sender).and_return(subscription)
    end

    it 'relays the message and notifies the sender' do
      expect_notification_of [other_subscriber], 'RelayNotification'
      expect_response_to_sender 'RelayConfirmationResponse'
      execute
    end

    context 'and anonymous' do
      before do
        allow(sender).to receive(:anonymous?).and_return(true)
      end

      it 'relays the message, notifies the sender, and identifies the anon to admins' do
        expect_notification_of [other_subscriber], 'RelayNotification'
        expect_response_to_sender 'RelayConfirmationResponse'
        expect_notification_of_admins 'AnonRelayNotification'
        execute
      end
    end

    context 'to a relay that is frozen' do
      before do
        allow(relay).to receive(:frozen).and_return(true)
      end

      it 'responds that the relay is frozen' do
        expect_response_to_sender 'FrozenBounceResponse'
        expect_notification_of_admins 'FrozenBounceNotification'
        execute
      end
    end

    context 'to a relay that is moderated' do
      before do
        allow(relay).to receive(:moderated).and_return(true)
      end

      it 'responds that the relay is moderated and notifies admins' do
        expect_response_to_sender 'ModeratedBounceResponse'
        expect_notification_of_admins 'ModeratedBounceNotification'
        execute
      end

      context 'from a subscriber that is an admin' do
        before do
          allow(sender).to receive(:admin).and_return(true)
        end

        it 'relays the message' do
          expect_notification_of [other_subscriber], 'RelayNotification'
          expect_response_to_sender 'RelayConfirmationResponse'
          execute
        end
      end

      context 'from a sender who is voiced' do
        before do
          allow(subscription).to receive(:voiced).and_return(true)
        end

        it 'relays the message' do
          expect_notification_of [other_subscriber], 'RelayNotification'
          expect_response_to_sender 'RelayConfirmationResponse'
          execute
        end
      end
    end

    context 'when the sender is muted' do
      before do
        allow(subscription).to receive(:muted).and_return(true)
      end

      it 'notifies admins and responds that the sender is muted' do
        expect_response_to_sender 'MutedBounceResponse'
        expect_notification_of_admins 'MutedBounceNotification'
        execute
      end
    end
  end

  context 'from a sender who is not subscribed' do

    before do
      allow(relay).to receive(:subscribed?).with(sender).and_return(false)
    end

    it 'responds that the sender is not subscribed' do
      expect_response_to_sender 'NotSubscribedRelayBounceResponse'
      expect_notification_of_admins 'NotSubscribedRelayBounceNotification'
      execute
    end
  end
end
