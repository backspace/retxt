class Unvoice
  def initialize(command_context)
    @command_context = command_context
    @sender = command_context.sender
    @relay = command_context.relay

    @arguments = command_context.arguments
  end

  def execute
    ModifySubscription.new(@command_context, success_response: SubscriptionModificationNotification.new(@command_context, 'unvoice'), modifier: modifier).execute
  end

  private
  def modifier
    lambda do |subscription|
      subscription.unvoice
    end
  end
end
