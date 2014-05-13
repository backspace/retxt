class Create
  def initialize(command_context)
    @command_context = command_context
    @sender = command_context.sender
    @relay = command_context.relay

    @application_url = command_context.application_url

    @arguments = command_context.arguments
  end

  def execute
    if @sender.admin
      new_relay_area_code = ExtractsAreaCodes.new(@relay.number).extract_area_code
      new_relay_number = BuysNumbers.buy_number(new_relay_area_code, @application_url)
      relay = Relay.create(name: @arguments, number: new_relay_number)
      Subscription.create(relay: relay, subscriber: @sender)

      CreationNotification.new(@command_context).deliver(relay.admins)
    else
      NonAdminResponse.new(@command_context).deliver(@sender)
    end
  end
end
