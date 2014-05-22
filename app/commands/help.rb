require_relative 'abstract_command'

class Help < AbstractCommand
  def execute
    HelpResponse.new(context).deliver sender
    AdminHelpResponse.new(context).deliver sender if sender.admin
  end
end
