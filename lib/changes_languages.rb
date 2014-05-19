class ChangesLanguages
  def initialize(subscriber, language)
    @subscriber = subscriber
    @language = language
  end

  def change_language
    parsed_language = ParsesLanguages.new(language).parse

    if parsed_language
      subscriber.update_language(parsed_language)
      true
    else
      false
    end
  end

  protected
  def subscriber
    @subscriber
  end

  def language
    @language
  end
end
