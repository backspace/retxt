class ModifySubscription
  def initialize(command_context, options = {})
    @command_context = command_context
    @sender = command_context.sender
    @relay = command_context.relay
    @arguments = command_context.arguments

    @modifier = options[:modifier]
    @success_response = options[:success_response]
  end

  def execute
    return reject_unless_admin unless @sender.admin
    return reject_missing_target unless target = FindsSubscribers.find(@arguments)
    return reject_unsubscribed_target unless @subscription = @relay.subscription_for(target)

    modify_subscription
    notify_admins
  end

  private
  def reject_unless_admin
    NonAdminResponse.new(@command_context).deliver @sender
  end

  def reject_missing_target
    MissingTargetResponse.new(@command_context).deliver @sender
  end

  def reject_unsubscribed_target
    UnsubscribedTargetResponse.new(@command_context).deliver @sender
  end

  def modify_subscription
    @modifier.call(@subscription)
  end

  def notify_admins
    @success_response.deliver @relay.admins
  end
end
