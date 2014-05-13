class Unadmin
  def initialize(command_context)
    @command_context = command_context
    @sender = command_context.sender
    @relay = command_context.relay

    @arguments = command_context.arguments
  end

  def execute
    if @sender.admin
      unadminee = FindsSubscribers.find(@arguments)

      if unadminee
        unadminee.unadmin!
        UnadminificationNotification.new(@command_context).deliver(@relay.admins)
      else
        MissingTargetResponse.new(@command_context).deliver(@sender)
      end
    else
      NonAdminResponse.new(@command_context).deliver(@sender)
    end
  end
end
