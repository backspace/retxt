class ParsesCommands
  def initialize(command, context, structure = COMMAND_STRUCTURE)
    @command = command
    @context = context
    @structure = structure

    @command_hash = {}
  end

  def parse
    command_class_name.camelize.constantize
  end

  def locale
    @locale
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

  def command_is_banged?
    command.start_with? "!"
  end

  def slashless_command
    @slashless_command ||= command[1..-1]
  end

  def command_class_name
    if command_is_addressed?
      'direct_message'
    elsif command_is_banged?
      'bang'
    else
      I18n.available_locales.each do |locale|
        @matching_command = find_matching_command(select_locale_setting_keys(command_hash_in_locale(locale)))

        if @matching_command
          @locale = locale
          break
        end
      end

      @matching_command = find_matching_command(command_hash_in_locale(@context.locale || I18n.default_locale)) unless @matching_command

      if @matching_command
        @matching_command.first.to_s
      elsif command_is_slashed?
        'unknown'
      else
        'relay_command'
      end
    end
  end

  def command_hash_in_locale(locale)
    @command_hash[locale] ||= I18n.t('commands', locale: locale)
  end

  def requires_slash?(command)
    keys_requiring_slash.include? command
  end

  def keys_requiring_slash
    @structure[:slash_requiring] || []
  end

  def select_locale_setting_keys(command_hash)
    command_hash.select{|key, value| locale_setting_keys.include? key}
  end

  def locale_setting_keys
    @structure[:locale_setting] || []
  end

  def matches_command?(candidates, command)
    candidates.is_a?(Array) ? candidates.include?(command) : candidates == command
  end

  def find_matching_command(commands)
    commands.find do |key, value|
      if requires_slash?(key) && command_is_slashed?
        matches_command?(value, slashless_command)
      else
        matches_command?(value, command)
      end
    end
  end
end
