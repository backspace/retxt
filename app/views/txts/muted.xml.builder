xml.Response do
  xml.Sms t('txts.mute', mutee_name: @mutee.addressable_name)
end
