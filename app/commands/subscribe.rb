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
    if @relay.subscribed?(@sender)
      SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.already_subscribed'), originating_txt_id: @command_context.originating_txt_id)
    else
      if @relay.closed
        SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.close'), originating_txt_id: @command_context.originating_txt_id)
        TxtsRelayAdmins.txt_relay_admins(relay: @relay, body: I18n.t('txts.bounce_notification', number: @sender.number, message: "subscribe#{@arguments.present? ? " #{@arguments}" : ''}"), originating_txt_id: @command_context.originating_txt_id)
      else
        if @sender.persisted?
          subscriber = @sender
        else
          subscriber = @subscriberRepository.create(number: @sender.number)
        end

        @subscriptionRepository.create(relay: @relay, subscriber: subscriber)

        ChangesNames.change_name(subscriber, @arguments) if @arguments

        other_subscribers = @relay.subscription_count - 1
        other_subscribers_text = I18n.t('other', count: other_subscribers)

        SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.welcome', relay_name: @relay.name, subscriber_name: subscriber.name_or_anon, subscriber_count: other_subscribers_text), originating_txt_id: @command_context.originating_txt_id)
        SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.disclaimer'), originating_txt_id: @command_context.originating_txt_id)

        TxtsRelayAdmins.txt_relay_admins(relay: @relay, body: I18n.t('txts.admin.subscribed', name: subscriber.name_or_anon, number: @sender.number), originating_txt_id: @command_context.originating_txt_id)
      end
    end
  end
end
