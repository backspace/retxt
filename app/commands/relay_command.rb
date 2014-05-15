class RelayCommand
  def initialize(command_context)
    @command_context = command_context
    @sender = command_context.sender
    @relay = command_context.relay

    @txt = command_context.txt
    @content = @txt.body
  end

  def execute
    return not_subscribed unless sender_subscribed?
    return frozen if @relay.frozen
    return suppress_voiceless if relay_moderated_and_sender_voiceless?
    return muted if sender_muted?

    relay
  end

  private
  def sender_subscribed?
    @relay.subscribed?(@sender)
  end

  def not_subscribed
    NotSubscribedBounceResponse.new(@command_context).deliver @sender
  end

  def frozen
    FrozenBounceResponse.new(@command_context).deliver @sender
  end

  def relay_moderated_and_sender_voiceless?
    @relay.moderated && !@sender.admin && !@relay.subscription_for(@sender).voiced
  end

  def suppress_voiceless
    ModeratedBounceResponse.new(@command_context).deliver @sender
    ModeratedBounceNotification.new(@command_context).deliver @relay.admins
  end

  def sender_muted?
    @relay.subscription_for(@sender).muted
  end

  def muted
    MutedBounceResponse.new(@command_context).deliver @sender
    MutedBounceNotification.new(@command_context).deliver @relay.admins
  end

  def relay
    RelayNotification.new(@command_context).deliver(@relay.subscribers - [@sender])
    RelayConfirmationResponse.new(@command_context).deliver(@sender)

    identify_anonymous_to_admins if @sender.anonymous?
  end

  def identify_anonymous_to_admins
    AnonRelayNotification.new(@command_context).deliver @relay.admins
  end
end
