require_relative 'abstract_command'

class Close < AbstractCommand
  def execute
    ModifyRelay.new(context, modifier: :close, success_response: RelayModificationNotification.new(context, 'close')).execute
  end
end
