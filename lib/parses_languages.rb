class ParsesLanguages
  def initialize(language)
    @language = language.downcase
  end

  def parse
    locales.map do |locale|
      localised_language_name = I18n.t('language_name', locale: locale).downcase

      return locale if localised_language_name.start_with?(language)
    end

    false
  end

  private
  def language
    @language
  end

  def locales
    I18n.available_locales
  end
end
