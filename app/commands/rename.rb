require_relative 'abstract_command'

class Rename < AbstractCommand
  def execute
    if sender.admin
      relay.rename(arguments)
      RenameNotification.new(context).deliver relay.admins
    else
      NonAdminBounceResponse.new(context).deliver sender
      NonAdminBounceNotification.new(context).deliver relay.admins
    end
  end
end
