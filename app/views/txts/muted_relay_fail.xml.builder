xml.Response do
  xml.Sms I18n.t('txts.muted_fail')

  @admin_destinations.each do |destination|
    xml.Sms I18n.t('txts.muted_report', mutee_name: @mutee.addressable_name, muted_message: @original_message).truncate(160), to: destination
  end
end
