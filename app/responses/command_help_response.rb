class CommandHelpResponse < SimpleResponse
  private
  def template_parameters(subscriber)
    if command_key == 'unknown'
      {command: arguments}
    else
      {}
    end
  end

  def template_name
    "command_help.#{command_key}"
  end

  def command_key
    @command_key ||= ParsesHelpCommand.new(arguments, sender.locale).parse || 'unknown'
  end
end
