class RelayedTxtFormatter
  def initialize(options)
    @sender = options[:sender]
    @txt = options[:txt]
  end

  def format
    "#{@sender.addressable_name} sez: #{@txt}"
  end
end
