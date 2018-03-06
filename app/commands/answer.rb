require_relative 'abstract_command'

class Answer < AbstractCommand
  def execute
    meeting = Meeting.where(code: code).first

    if meeting
      context.txt.body =~ /\s(.*)/
      given_answer = $1

      if given_answer.downcase == meeting.answer.downcase
        context.meeting = meeting
        AnswerResponse.new(context).deliver sender
      else
        AnswerIncorrectBounceResponse.new(context).deliver sender
      end
    else
      AnswerMeetingBounceResponse.new(context).deliver sender
    end
  end

  private
  def code
    context.txt.body.split[0][1..-1]
  end
end
