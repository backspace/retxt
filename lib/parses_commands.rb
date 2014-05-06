class ParsesCommands
  def initialize(command, context, structure = COMMAND_STRUCTURE)
    @command = command
    @context = context
    @structure = structure
  end

  def parse
    command_class_name.camelize.constantize
  end

  protected
  def command
    @command
  end

  def command_is_slashed?
    command.start_with? "/"
  end

  def command_is_addressed?
    command.start_with? "@"
  end

  def slashless_command
    @slashless_command ||= command[1..-1]
  end

  def command_class_name
    if command_is_addressed?
      'direct_message'
    else
      matching_command = command_hash.find do |key, value|
        if requires_slash?(key) && command_is_slashed?
          matches_command?(value, slashless_command)
        else
          matches_command?(value, command)
        end
      end

      if matching_command
        matching_command.first.to_s
      elsif command_is_slashed?
        'unknown'
      else
        'relay_command'
      end
    end
  end

  def command_hash
    @command_hash ||= I18n.t('commands')
  end

  def requires_slash?(command)
    keys_requiring_slash.include? command
  end

  def keys_requiring_slash
    @structure[:slash_requiring] || []
  end

  def matches_command?(candidates, command)
    candidates.is_a?(Array) ? candidates.include?(command) : candidates == command
  end
end
