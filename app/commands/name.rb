require_relative 'abstract_command'

class Name < AbstractCommand
  def execute
    ChangesNames.change_name(sender, arguments)
    NameResponse.new(context).deliver sender
  end
end
