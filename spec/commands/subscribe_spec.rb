require_relative '../../app/commands/subscribe'
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
    Subscribe.new(sender: sender, relay: relay, i18n: i18n, sends_txts: sends_txts, arguments: arguments, subscriberRepository: subscriberRepository, subscriptionRepository: subscriptionRepository).execute
  end

  context 'when the sender is not subscribed' do
    before do
      relay.stub(:subscribed?).with(sender).and_return(false)
      sender.stub(:persisted?).and_return(false)
    end

    it 'subscribes the sender and notifies admins' do
      subscriber = double('subscriber', name_or_anon: 'anon')
      subscriberRepository.should_receive(:create).with(number: sender.number).and_return(subscriber)
      subscriptionRepository.should_receive(:create).with(relay: relay, subscriber: subscriber)

      i18n.should_receive('t').with('txts.welcome', relay_name: relay.name, subscriber_name: 'anon').and_return('welcome')
      sends_txts.should_receive(:send_txt).with(to: sender.number, from: relay.number, body: 'welcome')

      i18n.should_receive('t').with('txts.disclaimer').and_return('disclaimer')
      sends_txts.should_receive(:send_txt).with(to: sender.number, from: relay.number, body: 'disclaimer')


      i18n.should_receive('t').with('txts.admin.subscribed', name: 'anon', number: sender.number).and_return('subscribed')
      TxtsRelayAdmins.should_receive(:txt_relay_admins).with(relay: relay, body: 'subscribed')

      execute
    end

    context 'when a name is provided' do
      let(:arguments) { 'aname' }

      it 'subscribes the sender, changes their name, and notifies admins' do
        subscriber = double('subscriber', name_or_anon: 'anon')
        subscriberRepository.should_receive(:create).with(number: sender.number).and_return(subscriber)
        subscriptionRepository.should_receive(:create).with(relay: relay, subscriber: subscriber)

        ChangesNames.should_receive(:change_name).with(subscriber, arguments)
        subscriber.stub(:name_or_anon).and_return(arguments)

        i18n.should_receive('t').with('txts.welcome', relay_name: relay.name, subscriber_name: arguments).and_return('welcome')
        sends_txts.should_receive(:send_txt).with(to: sender.number, from: relay.number, body: 'welcome')

        i18n.should_receive('t').with('txts.disclaimer').and_return('disclaimer')
        sends_txts.should_receive(:send_txt).with(to: sender.number, from: relay.number, body: 'disclaimer')


        i18n.should_receive('t').with('txts.admin.subscribed', name: arguments, number: sender.number).and_return('subscribed')
        TxtsRelayAdmins.should_receive(:txt_relay_admins).with(relay: relay, body: 'subscribed')

        execute
      end
    end

    context 'when the relay is closed' do
      before do
        relay.stub(:closed).and_return(true)
      end

      it 'bounces the sender and notifies admins' do
        i18n.should_receive('t').with('txts.close').and_return('closed')
        sends_txts.should_receive(:send_txt).with(to: sender.number, from: relay.number, body: 'closed')

        i18n.should_receive('t').with('txts.bounce_notification', number: sender.number, message: "subscribe#{arguments.present? ? " #{arguments}" : ''}").and_return('bounce')
        TxtsRelayAdmins.should_receive(:txt_relay_admins).with(relay: relay, body: 'bounce')

        execute
      end
    end

    context 'when the sender is a subscriber to another relay' do
      before do
        sender.stub(:persisted?).and_return(true)
        sender.stub(:name_or_anon).and_return('anon')
      end

      it 'creates a subscription and notifies admins' do
        subscriptionRepository.should_receive(:create).with(relay: relay, subscriber: sender)

        i18n.should_receive('t').with('txts.welcome', relay_name: relay.name, subscriber_name: 'anon').and_return('welcome')
        sends_txts.should_receive(:send_txt).with(to: sender.number, from: relay.number, body: 'welcome')

        i18n.should_receive('t').with('txts.disclaimer').and_return('disclaimer')
        sends_txts.should_receive(:send_txt).with(to: sender.number, from: relay.number, body: 'disclaimer')


        i18n.should_receive('t').with('txts.admin.subscribed', name: 'anon', number: sender.number).and_return('subscribed')
        TxtsRelayAdmins.should_receive(:txt_relay_admins).with(relay: relay, body: 'subscribed')

        execute
      end
    end
  end

  context 'when the sender is already subscribed' do
    before do
      relay.stub(:subscribed?).with(sender).and_return(true)
    end

    it 'sends the already-subscribed message' do
      i18n.should_receive('t').with('txts.already_subscribed').and_return('already subscribed')

      sends_txts.should_receive(:send_txt).with(to: sender.number, from: relay.number, body: 'already subscribed')

      execute
    end
  end
end
