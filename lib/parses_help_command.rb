class ParsesHelpCommand
  def initialize(command, locale)
    @command = clean(command)
    @locale = locale
  end

  def parse
    pair = matching_key_pair

    pair.first if pair
  end

  private
  def command
    @command
  end

  def clean(command)
    command.downcase!

    if command.start_with? '/'
      command[1..-1]
    else
      command
    end
  end

  def locale
    @locale
  end

  def matching_key_pair
    I18n.t('commands', locale: locale).find{|key, value| value = [value] unless value.is_a? Array; value.include? command}
  end
end
