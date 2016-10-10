require_relative 'abstract_command'

class Invite < AbstractCommand
  def initialize(command_context, options = {})
    super command_context

    @invitation_repository = options[:invitation_repository] || Invitation
  end

  def execute
    if relay.invited? arguments
      AdminInviteBounceResponse.new(context).deliver(sender)
    else
      InviteResponse.new(context).deliver(Subscriber.new(number: arguments))
      AdminInviteResponse.new(context).deliver(sender)
      @invitation_repository.create(relay: relay, number: arguments)
    end
  end
end
