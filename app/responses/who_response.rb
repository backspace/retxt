class WhoResponse < SimpleResponse
  def body
    response = ""

    relay.subscriptions.sort_by(&:created_at).each do |subscription|
      subscriber = subscription.subscriber
      response << "#{subscriber.addressable_name}#{subscriber.admin ? '*' : ''}#{subscription_states(subscription)} #{subscriber.number}\n"
    end

    response
  end

  def deliver(recipient)
    SendsTxts.send_txts(
      from: origin_of_txt,
      to: recipient.number,
      body: body,
      originating_txt_id: @context.originating_txt_id
    )
  end

  private
  def subscription_states(subscription)
    s = ""

    s << " (muted)" if subscription.muted
    s << " (voiced)" if subscription.voiced

    s
  end
end
