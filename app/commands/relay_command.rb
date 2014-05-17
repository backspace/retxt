require_relative 'abstract_command'

class RelayCommand < AbstractCommand
  def execute
    return not_subscribed unless sender_subscribed?
    return frozen if relay.frozen
    return suppress_voiceless if relay_moderated_and_sender_voiceless?
    return muted if sender_muted?

    relay_message
  end

  private
  def sender_subscribed?
    relay.subscribed?(sender)
  end

  def not_subscribed
    NotSubscribedBounceResponse.new(context).deliver sender
    NotSubscribedBounceNotification.new(context).deliver relay.admins
  end

  def frozen
    FrozenBounceResponse.new(context).deliver sender
    FrozenBounceNotification.new(context).deliver relay.admins
  end

  def relay_moderated_and_sender_voiceless?
    relay.moderated && !sender.admin && !relay.subscription_for(sender).voiced
  end

  def suppress_voiceless
    ModeratedBounceResponse.new(context).deliver sender
    ModeratedBounceNotification.new(context).deliver relay.admins
  end

  def sender_muted?
    relay.subscription_for(sender).muted
  end

  def muted
    MutedBounceResponse.new(context).deliver sender
    MutedBounceNotification.new(context).deliver relay.admins
  end

  def relay_message
    RelayNotification.new(context).deliver(relay.subscribers - [sender])
    RelayConfirmationResponse.new(context).deliver(sender)

    identify_anonymous_to_admins if sender.anonymous?
  end

  def identify_anonymous_to_admins
    AnonRelayNotification.new(context).deliver relay.admins
  end
end
