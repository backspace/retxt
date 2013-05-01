class FindsSubscribers
  def self.find(identifier)
    if identifier =~ /^\d+$/
      Subscriber.where(number: Regexp.new(identifier)).first
    else
      if identifier.starts_with? '@'
        identifier = identifier[1..-1]
      end

      Subscriber.where(name: identifier).first
    end
  end
end
