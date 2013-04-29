sms_attributes = {}

if defined?(@from)
  sms_attributes[:from] = @from
end

xml.Response do
  xml.Sms @content, sms_attributes
end
