xml.Response do
  xml.Sms t('txts.unmute', unmutee_name: @unmutee.addressable_name)
end
