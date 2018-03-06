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
        CopyNotification.new(context, 'correct answer').deliver relay.admins
      else
        AnswerIncorrectBounceResponse.new(context).deliver sender
        CopyNotification.new(context, 'incorrect answer').deliver relay.admins
      end
    else
      CopyNotification.new(context, 'incorrect answer meeting').deliver relay.admins
      AnswerMeetingBounceResponse.new(context).deliver sender
    end
  end

  private
  def code
    context.txt.body.split[0][1..-1]
  end
end
