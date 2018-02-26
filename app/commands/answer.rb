require_relative 'abstract_command'

class Answer < AbstractCommand
  def execute
    meeting = Meeting.find_by(code: code)

    context.txt.body =~ /\s(.*)/
    given_answer = $1

    if given_answer == meeting.answer
      AnswerResponse.new(context).deliver sender
    else
      AnswerIncorrectBounceResponse.new(context).deliver sender
    end
  end

  private
  def code
    context.txt.body.split[0][1..-1]
  end
end
