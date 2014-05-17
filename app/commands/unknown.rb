require_relative 'abstract_command'

class Unknown < AbstractCommand
  def execute
    UnknownBounceResponse.new(context).deliver sender
  end
end
