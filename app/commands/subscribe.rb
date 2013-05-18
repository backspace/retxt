class Subscribe
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]
    @i18n = options[:i18n] || I18n
    @sends_txts = options[:sends_txts] || SendsTxts
    @subscriberRepository = options[:subscriberRepository] || Subscriber
    @subscriptionRepository = options[:subscriptionRepository] || Subscription
    @arguments = options[:arguments]
  end

  def execute
    if @relay.subscribed?(@sender)
      @sends_txts.send_txt(from: @relay.number, to: @sender.number, body: @i18n.t('txts.already_subscribed'))
    else
      if @relay.closed
        @sends_txts.send_txt(from: @relay.number, to: @sender.number, body: @i18n.t('txts.close'))
        TxtsRelayAdmins.txt_relay_admins(relay: @relay, body: @i18n.t('txts.bounce_notification', number: @sender.number, message: "subscribe#{@arguments.present? ? " #{@arguments}" : ''}"))
      else
        if @sender.persisted?
          subscriber = @sender
        else
          subscriber = @subscriberRepository.create(number: @sender.number)
        end

        @subscriptionRepository.create(relay: @relay, subscriber: subscriber)

        ChangesNames.change_name(subscriber, @arguments) if @arguments

        @sends_txts.send_txt(from: @relay.number, to: @sender.number, body: @i18n.t('txts.welcome', relay_name: @relay.name, subscriber_name: subscriber.name_or_anon))
        @sends_txts.send_txt(from: @relay.number, to: @sender.number, body: @i18n.t('txts.disclaimer'))

        TxtsRelayAdmins.txt_relay_admins(relay: @relay, body: @i18n.t('txts.admin.subscribed', name: subscriber.name_or_anon, number: @sender.number))
      end
    end
  end
end
