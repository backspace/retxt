require_relative 'abstract_command'

class Question < AbstractCommand
  def execute
    meeting = Meeting.all.to_a.find{|meeting| meeting.full_code == code}

    if meeting
      context.meeting = meeting
      QuestionResponse.new(context).deliver sender
      CopyNotification.new(context, 'correct meeting code').deliver relay.admins
    else
      QuestionBounceResponse.new(context).deliver sender
      CopyNotification.new(context, 'incorrect meeting code').deliver relay.admins
    end
  end

  private
  def code
    context.txt.body[1..-1]
  end
end
