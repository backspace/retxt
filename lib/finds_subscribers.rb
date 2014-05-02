class FindsSubscribers
  def self.find(identifier)
    identifier.strip!

    if identifier =~ /^\d+$/
      Subscriber.where(number: Regexp.new(identifier)).first
    elsif identifier[0] == "+" && identifier[1..-1] =~ /^\d+$/
      Subscriber.where(number: Regexp.new(identifier[1..-1])).first
    else
      if identifier.starts_with? '@'
        identifier = identifier[1..-1]
      end

      Subscriber.where(name: identifier).first
    end
  end
end
