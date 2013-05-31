class WhoResponse
  def self.generate(options)
    relay = options[:relay]

    response = ""

    relay.subscribers.each do |subscriber|
      response << "#{subscriber.addressable_name}#{subscriber.admin ? '*' : ''} #{subscriber.number}\n"
    end

    response
  end
end
