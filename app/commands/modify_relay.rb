class ModifyRelay
  def initialize(command_context, options)
    @command_context = command_context
    @sender = command_context.sender
    @relay = command_context.relay

    @modifier = options[:modifier]
    @arguments = command_context.arguments
    @success_response = options[:success_response]
  end

  def execute
    if @sender.admin
      if @arguments
        @relay.send(@modifier, @arguments)
      else
        @relay.send(@modifier)
      end
      @success_response.deliver @relay.admins
    else
      NonAdminResponse.new(@command_context).deliver @sender
    end
  end
end
