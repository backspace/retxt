class Subscribe
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]
    @subscriberRepository = options[:subscriberRepository] || Subscriber
    @subscriptionRepository = options[:subscriptionRepository] || Subscription
    @arguments = options[:arguments]
  end

  def execute
    if @relay.subscribed?(@sender)
      SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.already_subscribed'))
    else
      if @relay.closed
        SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.close'))
        TxtsRelayAdmins.txt_relay_admins(relay: @relay, body: I18n.t('txts.bounce_notification', number: @sender.number, message: "subscribe#{@arguments.present? ? " #{@arguments}" : ''}"))
      else
        if @sender.persisted?
          subscriber = @sender
        else
          subscriber = @subscriberRepository.create(number: @sender.number)
        end

        @subscriptionRepository.create(relay: @relay, subscriber: subscriber)

        ChangesNames.change_name(subscriber, @arguments) if @arguments

        SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.welcome', relay_name: @relay.name, subscriber_name: subscriber.name_or_anon))
        SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.disclaimer'))

        TxtsRelayAdmins.txt_relay_admins(relay: @relay, body: I18n.t('txts.admin.subscribed', name: subscriber.name_or_anon, number: @sender.number))
      end
    end
  end
end
