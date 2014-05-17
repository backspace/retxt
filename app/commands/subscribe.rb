require 'active_support/core_ext/object/blank'

require_relative 'abstract_command'

class Subscribe < AbstractCommand
  def initialize(command_context, options = {})
    super command_context

    @subscriberRepository = options[:subscriberRepository] || Subscriber
    @subscriptionRepository = options[:subscriptionRepository] || Subscription
    @arguments = command_context.arguments
  end

  def execute
    return already_subscribed if sender_subscribed?
    return relay_closed if relay.closed

    subscribe_sender
  end

  private
  def sender_subscribed?
    relay.subscribed?(sender)
  end

  def already_subscribed
    AlreadySubscribedBounceResponse.new(context).deliver(sender)
  end

  def relay_closed
    ClosedResponse.new(context).deliver(sender)
    ClosedBounceNotification.new(context).deliver(relay.admins)
  end

  def subscribe_sender
    persist_subscriber
    @subscriptionRepository.create(relay: relay, subscriber: @subscriber)

    ChangesNames.change_name(@subscriber, arguments) if arguments

    send_welcome_messages
    notify_admins
  end

  def persist_subscriber
    if sender.persisted?
      @subscriber = sender
      @subscriber.locale = context.locale
      @subscriber.save
    else
      @subscriber = @subscriberRepository.create(number: sender.number, locale: context.locale)
    end
  end

  def send_welcome_messages
    WelcomeResponse.new(context).deliver(sender)
    DisclaimerResponse.new(context).deliver(sender)
  end

  def notify_admins
    SubscriptionNotification.new(context).deliver(relay.admins)
  end
end
