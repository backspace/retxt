class Admin
  def initialize(command_context)
    @command_context = command_context
    @sender = command_context.sender
    @relay = command_context.relay

    @arguments = command_context.arguments
  end

  def execute
    if @sender.admin
      adminee = FindsSubscribers.find(@arguments)

      if adminee
        adminee.admin!

        AdminificationNotification.new(@command_context).deliver(@relay.admins)
      else
        MissingTargetBounceResponse.new(@command_context).deliver(@sender)
      end
    else
      NonAdminBounceResponse.new(@command_context).deliver(@sender)
    end
  end
end
