require_relative 'abstract_command'

class Freeze < AbstractCommand
  def execute
    ModifyRelay.new(context, modifier: :freeze, success_response: RelayModificationNotification.new(context, 'freeze')).execute
  end
end
