class Clear
  def initialize(command_context)
    @command_context = command_context
    @sender = command_context.sender
    @relay = command_context.relay
  end

  def execute
    if @sender.admin
      @relay.non_admins.each do |subscriber|
        @relay.subscription_for(subscriber).destroy
      end

      ClearNotification.new(@command_context).deliver(@relay.admins)
    else
      NonAdminResponse.new(@command_context).deliver(@sender)
    end
  end
end
