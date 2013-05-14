xml.Response do
  xml.Sms I18n.t('txts.close')

  @admin_destinations.each do |number|
    xml.Sms I18n.t('txts.bounce_notification', number: params[:From], message: params[:Body]), to: number
  end
end
