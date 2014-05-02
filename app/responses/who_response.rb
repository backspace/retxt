class WhoResponse
  def self.generate(options)
    relay = options[:relay]

    response = ""

    relay.subscriptions.sort_by(&:created_at).each do |subscription|
      subscriber = subscription.subscriber
      response << "#{subscriber.addressable_name}#{subscriber.admin ? '*' : ''}#{subscription_states(subscription)} #{subscriber.number}\n"
    end

    response
  end

  private
  def self.subscription_states(subscription)
    s = ""

    s << " (muted)" if subscription.muted
    s << " (voiced)" if subscription.voiced

    s
  end
end
