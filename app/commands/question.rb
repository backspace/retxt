require_relative 'abstract_command'

class Question < AbstractCommand
  def execute
    meeting = Meeting.all.to_a.find{|meeting| meeting.full_code == code}

    if meeting
      QuestionResponse.new(context).deliver sender
    else
      QuestionBounceResponse.new(context).deliver sender
    end
  end

  private
  def code
    context.txt.body[1..-1]
  end
end
