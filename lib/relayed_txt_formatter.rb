class RelayedTxtFormatter
  def initialize(options)
    @relay = options[:relay]
    @sender = options[:sender]
    @recipient = options[:recipient]
    @txt = options[:txt]
  end

  def format
    I18n.t('txts.relay_template', time: timestring, sender: @sender.addressable_name, body: @txt.body, locale: @recipient.locale)
  end

  def timestring
    TimestampFormatter.new(relay: @relay, txt: @txt).format
  end
end
