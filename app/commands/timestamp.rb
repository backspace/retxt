require_relative 'abstract_command'

class Timestamp < AbstractCommand
  def execute
    ModifyRelay.new(context, modifier: :timestamp!, success_response: TimestampModificationNotification.new(context)).execute
  end
end
