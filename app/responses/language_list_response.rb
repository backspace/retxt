class LanguageListResponse < SimpleResponse
  def body_for(recipient)
    list = I18n.available_locales.map{|locale| I18n.t('language_name', locale: locale)}.join ", "
    I18n.t('txts.language_list', language_list: list, locale: recipient.locale)
  end

  def deliver(recipient)
    SendsTxts.send_txt(
      from: origin_of_txt,
      to: recipient.number,
      body: body_for(recipient),
      originating_txt_id: @context.originating_txt_id
    )
  end
end
