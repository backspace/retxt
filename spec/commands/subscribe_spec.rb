require_relative '../../app/commands/subscribe'

require_relative '../../app/responses/subscription_notification'
require_relative '../../app/responses/welcome_response'
require_relative '../../app/responses/disclaimer_response'

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


      WelcomeResponse.should_receive(:new).with(command_context).and_return(double.tap{|mock| mock.should_receive(:deliver).with(sender)})
      DisclaimerResponse.should_receive(:new).with(command_context).and_return(double.tap{|mock| mock.should_receive(:deliver).with(sender)})

      SubscriptionNotification.should_receive(:new).with(command_context).and_return(double.tap{|mock| mock.should_receive(:deliver)})

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

        WelcomeResponse.should_receive(:new).with(command_context).and_return(double.tap{|mock| mock.should_receive(:deliver).with(sender)})
        DisclaimerResponse.should_receive(:new).with(command_context).and_return(double.tap{|mock| mock.should_receive(:deliver).with(sender)})

        SubscriptionNotification.should_receive(:new).with(command_context).and_return(double.tap{|mock| mock.should_receive(:deliver)})

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

        WelcomeResponse.should_receive(:new).with(command_context).and_return(double.tap{|mock| mock.should_receive(:deliver).with(sender)})
        DisclaimerResponse.should_receive(:new).with(command_context).and_return(double.tap{|mock| mock.should_receive(:deliver).with(sender)})

        SubscriptionNotification.should_receive(:new).with(command_context).and_return(double.tap{|mock| mock.should_receive(:deliver)})

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
