require_relative 'abstract_command'

class Who < AbstractCommand
  def execute
    if sender.admin
      WhoResponse.new(context).deliver sender
    else
      NonAdminBounceResponse.new(context).deliver sender
      NonAdminBounceNotification.new(context).deliver relay.admins
    end
  end
end
