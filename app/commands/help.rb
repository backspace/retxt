require 'active_support/core_ext/object/blank'

require_relative 'abstract_command'

class Help < AbstractCommand
  def execute
    if arguments.blank?
      HelpResponse.new(context).deliver sender
      AdminHelpResponse.new(context).deliver sender if sender.admin
    else
      CommandHelpResponse.new(context).deliver sender
    end
  end
end
