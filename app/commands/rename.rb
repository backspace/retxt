class Rename
  def initialize(command_context)
    @command_context = command_context
    @sender = command_context.sender
    @relay = command_context.relay

    @arguments = command_context.arguments
  end

  def execute
    if @sender.admin
      @relay.rename(@arguments)
      SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.rename', relay_name: @arguments), originating_txt_id: @command_context.originating_txt_id)
    else
      SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.nonadmin'), originating_txt_id: @command_context.originating_txt_id)
    end
  end
end
