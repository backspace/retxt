require_relative 'abstract_command'

class Unmoderate < AbstractCommand
  def execute
    ModifyRelay.new(context, modifier: :unmoderate, success_response: RelayModificationNotification.new(context, 'unmoderate')).execute
  end
end
