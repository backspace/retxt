class RelayedTxtFormatter
  def initialize(options)
    @relay = options[:relay]
    @sender = options[:sender]
    @txt = options[:txt]
  end

  def format
    "#{timestring}#{@sender.addressable_name} sez: #{@txt.body}"
  end

  def timestring
    TimestampFormatter.new(relay: @relay, txt: @txt).format
  end
end
