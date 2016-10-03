require_relative 'abstract_command'

class Invite < AbstractCommand
  def execute
    AdminInviteResponse.new(context).deliver(sender)
    InviteResponse.new(context).deliver(Subscriber.new(number: arguments))
  end
end
