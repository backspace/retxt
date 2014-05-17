require_relative 'abstract_command'

class Moderate < AbstractCommand
  def execute
    ModifyRelay.new(context, modifier: :moderate, success_response: RelayModificationNotification.new(context, 'moderate')).execute
  end
end
