require_relative 'abstract_command'

class NotifyMeeting < AbstractCommand
  def execute(meeting, subscriber)
    NotifyMeetingResponse.new(context).deliver subscriber
  end
end
