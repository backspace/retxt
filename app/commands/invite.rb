require_relative 'abstract_command'

class Invite < AbstractCommand
  def execute
    InviteResponse.new(context).deliver(Subscriber.new(number: arguments))
    AdminInviteResponse.new(context).deliver(sender)
  end
end
