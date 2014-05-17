require_relative 'abstract_command'

class Help < AbstractCommand
  def execute
    HelpResponse.new(context).deliver sender
  end
end
