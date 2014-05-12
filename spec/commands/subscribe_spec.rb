require_relative '../../app/commands/subscribe'

require_relative '../../app/responses/subscription_notification'

require 'command_context'
require 'changes_names'
require 'txts_relay_admins'

describe Subscribe do
  include_context 'command context'

  let(:arguments) { nil }
  let(:subscriberRepository) { double('subscriber repository') }
  let(:subscriptionRepository) { double('subscription repository') }

  before do
    relay.stub(:closed).and_return(false)
  end

  def execute
    Subscribe.new(command_context, subscriberRepository: subscriberRepository, subscriptionRepository: subscriptionRepository).execute
  end

  context 'when the sender is not subscribed' do
    before do
      relay.stub(:subscribed?).with(sender).and_return(false)
      sender.stub(:persisted?).and_return(false)
    end

    it 'subscribes the sender and notifies admins' do
      subscriber = double('subscriber', name_or_anon: 'anon')
      subscriberRepository.should_receive(:create).with(number: sender.number, locale: command_context.locale).and_return(subscriber)
      subscriptionRepository.should_receive(:create).with(relay: relay, subscriber: subscriber)

      relay.should_receive(:subscription_count).and_return(5)
      I18n.should_receive('t').with('other', count: 4).and_return('4 others')

      I18n.should_receive('t').with('txts.welcome', relay_name: relay.name, subscriber_name: 'anon', subscriber_count: '4 others').and_return('welcome')
      SendsTxts.should_receive(:send_txt).with(to: sender.number, from: relay.number, body: 'welcome', originating_txt_id: command_context.originating_txt_id)

      I18n.should_receive('t').with('txts.disclaimer').and_return('disclaimer')
      SendsTxts.should_receive(:send_txt).with(to: sender.number, from: relay.number, body: 'disclaimer', originating_txt_id: command_context.originating_txt_id)


      notification = double(:notification)
      SubscriptionNotification.should_receive(:new).with(command_context).and_return(notification)
      notification.should_receive(:deliver).with(relay.admins)

      execute
    end

    context 'when a name is provided' do
      let(:arguments) { 'aname' }

      it 'subscribes the sender, changes their name, and notifies admins' do
        subscriber = double('subscriber', name_or_anon: 'anon')
        subscriberRepository.should_receive(:create).with(number: sender.number, locale: command_context.locale).and_return(subscriber)
        subscriptionRepository.should_receive(:create).with(relay: relay, subscriber: subscriber)

        ChangesNames.should_receive(:change_name).with(subscriber, arguments)
        subscriber.stub(:name_or_anon).and_return(arguments)

        relay.should_receive(:subscription_count).and_return(5)
        I18n.should_receive('t').with('other', count: 4).and_return('4 others')

        I18n.should_receive('t').with('txts.welcome', relay_name: relay.name, subscriber_name: arguments, subscriber_count: '4 others').and_return('welcome')
        SendsTxts.should_receive(:send_txt).with(to: sender.number, from: relay.number, body: 'welcome', originating_txt_id: command_context.originating_txt_id)

        I18n.should_receive('t').with('txts.disclaimer').and_return('disclaimer')
        SendsTxts.should_receive(:send_txt).with(to: sender.number, from: relay.number, body: 'disclaimer', originating_txt_id: command_context.originating_txt_id)


        notification = double(:notification)
        SubscriptionNotification.should_receive(:new).with(command_context).and_return(notification)
        notification.should_receive(:deliver).with(relay.admins)

        execute
      end
    end

    context 'when the relay is closed' do
      before do
        relay.stub(:closed).and_return(true)
      end

      it 'bounces the sender and notifies admins' do
        I18n.should_receive('t').with('txts.close').and_return('closed')
        SendsTxts.should_receive(:send_txt).with(to: sender.number, from: relay.number, body: 'closed', originating_txt_id: command_context.originating_txt_id)

        I18n.should_receive('t').with('txts.bounce_notification', number: sender.number, message: "subscribe#{arguments.present? ? " #{arguments}" : ''}").and_return('bounce')
        TxtsRelayAdmins.should_receive(:txt_relay_admins).with(relay: relay, body: 'bounce', originating_txt_id: command_context.originating_txt_id)

        execute
      end
    end

    context 'when the sender is a subscriber to another relay' do
      before do
        sender.stub(:persisted?).and_return(true)
        sender.stub(:name_or_anon).and_return('anon')
      end

      it 'sets the subscriber locale, creates a subscription, and notifies admins' do
        sender.should_receive(:locale=).with(command_context.locale)
        sender.should_receive(:save)

        subscriptionRepository.should_receive(:create).with(relay: relay, subscriber: sender)

        relay.should_receive(:subscription_count).and_return(5)
        I18n.should_receive('t').with('other', count: 4).and_return('4 others')

        I18n.should_receive('t').with('txts.welcome', relay_name: relay.name, subscriber_name: 'anon', subscriber_count: '4 others').and_return('welcome')
        SendsTxts.should_receive(:send_txt).with(to: sender.number, from: relay.number, body: 'welcome', originating_txt_id: command_context.originating_txt_id)

        I18n.should_receive('t').with('txts.disclaimer').and_return('disclaimer')
        SendsTxts.should_receive(:send_txt).with(to: sender.number, from: relay.number, body: 'disclaimer', originating_txt_id: command_context.originating_txt_id)


        notification = double(:notification)
        SubscriptionNotification.should_receive(:new).with(command_context).and_return(notification)
        notification.should_receive(:deliver).with(relay.admins)

        execute
      end
    end
  end

  context 'when the sender is already subscribed' do
    before do
      relay.stub(:subscribed?).with(sender).and_return(true)
    end

    it 'sends the already-subscribed message' do
      I18n.should_receive('t').with('txts.already_subscribed').and_return('already subscribed')

      SendsTxts.should_receive(:send_txt).with(to: sender.number, from: relay.number, body: 'already subscribed', originating_txt_id: command_context.originating_txt_id)

      execute
    end
  end
end
