require_relative 'abstract_command'

class Thaw < AbstractCommand
  def execute
    ModifyRelay.new(context, modifier: :thaw, success_response: RelayModificationNotification.new(context, 'thaw')).execute
  end
end
