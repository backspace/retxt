class TimestampFormatter
  def initialize(options)
    @relay = options[:relay]
    @txt = options[:txt]
  end

  def format
    if @relay.timestamp.present?
      "#{@txt.created_at.strftime(@relay.timestamp).strip} "
    else
      ""
    end
  end
end
