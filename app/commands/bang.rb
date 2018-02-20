require_relative 'abstract_command'

class Bang < AbstractCommand
  def execute
    meeting = Meeting.all.to_a.find{|meeting| meeting.code == code}

    if meeting
      BangResponse.new(context).deliver sender
    end
  end

  private
  def code
    context.txt.body[1..-1]
  end
end
