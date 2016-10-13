require_relative 'abstract_command'

class Invite < AbstractCommand
  def initialize(command_context, options = {})
    super command_context

    @invitation_repository = options[:invitation_repository] || Invitation
    @invitee_number = arguments
  end

  def execute
    unless sender.admin
      NonAdminBounceResponse.new(context).deliver sender
      NonAdminBounceNotification.new(context).deliver relay.admins
      return
    end

    if relay.number_subscribed? @invitee_number
      AlreadySubscribedInviteBounceResponse.new(context).deliver sender
      return
    end

    if relay.invited? @invitee_number
      AlreadyInvitedInviteBounceResponse.new(context).deliver(sender)
      return
    end

    # FIXME what happens if it’s an invalid number?
    InviteResponse.new(context).deliver(Subscriber.new(number: @invitee_number))
    AdminInviteResponse.new(context).deliver(sender)
    @invitation_repository.create(relay: relay, number: @invitee_number)
  end
end
