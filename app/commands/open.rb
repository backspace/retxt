require_relative 'abstract_command'

class Open < AbstractCommand
  def execute
    ModifyRelay.new(context, modifier: :open, success_response: RelayModificationNotification.new(context, 'open')).execute
  end
end
