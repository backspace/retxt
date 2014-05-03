class Name
  def initialize(command_context)
    @command_context = command_context
    @sender = command_context.sender
    @relay = command_context.relay

    @new_name = command_context.arguments
  end

  def execute
    ChangesNames.change_name(@sender, @new_name)
    SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.name', name: @sender.name_or_anon), originating_txt_id: @command_context.originating_txt_id)
  end
end
