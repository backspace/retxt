require 'active_support/core_ext/object/blank'

class Subscribe
  def initialize(command_context, options = {})
    @command_context = command_context
    @sender = command_context.sender
    @relay = command_context.relay
    @subscriberRepository = options[:subscriberRepository] || Subscriber
    @subscriptionRepository = options[:subscriptionRepository] || Subscription
    @arguments = command_context.arguments
  end

  def execute
    return already_subscribed if sender_subscribed?
    return relay_closed if @relay.closed

    subscribe_sender
  end

  private
  def sender_subscribed?
    @relay.subscribed?(@sender)
  end

  def already_subscribed
    AlreadySubscribedResponse.new(@command_context).deliver(@sender)
  end

  def relay_closed
    ClosedResponse.new(@command_context).deliver(@sender)
    BounceNotification.new(@command_context).deliver(@relay.admins)
  end

  def subscribe_sender
    persist_subscriber
    @subscriptionRepository.create(relay: @relay, subscriber: @subscriber)

    ChangesNames.change_name(@subscriber, @arguments) if @arguments

    send_welcome_messages
    notify_admins
  end

  def persist_subscriber
    if @sender.persisted?
      @subscriber = @sender
      @subscriber.locale = @command_context.locale
      @subscriber.save
    else
      @subscriber = @subscriberRepository.create(number: @sender.number, locale: @command_context.locale)
    end
  end

  def send_welcome_messages
    WelcomeResponse.new(@command_context).deliver(@sender)
    DisclaimerResponse.new(@command_context).deliver(@sender)
  end

  def notify_admins
    SubscriptionNotification.new(@command_context).deliver(@relay.admins)
  end
end
