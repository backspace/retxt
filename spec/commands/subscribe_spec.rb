require_relative '../../app/commands/subscribe'

require 'command_context'
require 'changes_names'

describe Subscribe do
  include_context 'command context'

  let(:arguments) { nil }
  let(:subscriberRepository) { double('subscriber repository') }
  let(:subscriptionRepository) { double('subscription repository') }

  before do
    allow(relay).to receive(:closed).and_return(false)
  end

  def execute
    Subscribe.new(command_context, subscriberRepository: subscriberRepository, subscriptionRepository: subscriptionRepository).execute
  end

  context 'when the sender is not subscribed' do
    before do
      allow(relay).to receive(:subscribed?).with(sender).and_return(false)
      allow(sender).to receive(:persisted?).and_return(false)
    end

    it 'subscribes the sender and notifies admins' do
      subscriber = double('subscriber', name_or_anon: 'anon')
      expect(subscriberRepository).to receive(:create).with(number: sender.number, locale: command_context.locale).and_return(subscriber)
      expect(subscriptionRepository).to receive(:create).with(relay: relay, subscriber: subscriber)


      expect_response_to_sender 'WelcomeResponse'
      expect_response_to_sender 'DisclaimerResponse'
      expect_notification_of_admins 'SubscriptionNotification'

      execute
    end

    context 'when a name is provided' do
      let(:arguments) { 'aname' }

      it 'subscribes the sender, changes their name, and notifies admins' do
        subscriber = double('subscriber', name_or_anon: 'anon')
        expect(subscriberRepository).to receive(:create).with(number: sender.number, locale: command_context.locale).and_return(subscriber)
        expect(subscriptionRepository).to receive(:create).with(relay: relay, subscriber: subscriber)

        expect(ChangesNames).to receive(:change_name).with(subscriber, arguments)
        allow(subscriber).to receive(:name_or_anon).and_return(arguments)

        expect_response_to_sender 'WelcomeResponse'
        expect_response_to_sender 'DisclaimerResponse'
        expect_notification_of_admins 'SubscriptionNotification'

        execute
      end
    end

    context 'when the relay is closed' do
      before do
        allow(relay).to receive(:closed).and_return(true)
      end

      it 'bounces the sender and notifies admins' do
        expect_response_to_sender 'ClosedResponse'
        expect_notification_of_admins 'ClosedBounceNotification'

        execute
      end
    end

    context 'when the sender is a subscriber to another relay' do
      before do
        allow(sender).to receive(:persisted?).and_return(true)
        allow(sender).to receive(:name_or_anon).and_return('anon')
      end

      it 'sets the subscriber locale, creates a subscription, and notifies admins' do
        expect(sender).to receive(:locale=).with(command_context.locale)
        expect(sender).to receive(:save)

        expect(subscriptionRepository).to receive(:create).with(relay: relay, subscriber: sender)

        expect_response_to_sender 'WelcomeResponse'
        expect_response_to_sender 'DisclaimerResponse'
        expect_notification_of_admins 'SubscriptionNotification'

        execute
      end
    end
  end

  context 'when the sender is already subscribed' do
    before do
      allow(relay).to receive(:subscribed?).with(sender).and_return(true)
    end

    it 'sends the already-subscribed message' do
      expect_response_to_sender 'AlreadySubscribedBounceResponse'

      execute
    end
  end
end
