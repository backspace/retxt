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

      TxtsRelayAdmins.txt_relay_admins(relay: relay, body: I18n.t('txts.admin.create', admin_name: @sender.addressable_name, relay_name: relay.name), originating_txt_id: @command_context.originating_txt_id)
    else
      SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.nonadmin'), originating_txt_id: @command_context.originating_txt_id)
    end
  end
end
