class CommandContext
  attr_accessor :sender
  attr_accessor :relay
  attr_accessor :originating_txt
  attr_accessor :arguments
  attr_accessor :application_url
  attr_accessor :meeting

  attr_accessor :locale

  def initialize(options = {})
    @sender = options[:sender]
    @relay = options[:relay]
    @originating_txt = options[:originating_txt]
    @arguments = options[:arguments]
    @application_url = options[:application_url]
    @locale = options[:locale]

    @meeting = options[:meeting]
  end

  def txt
    originating_txt
  end

  def originating_txt_id
    originating_txt.id.to_s
  end

  def ==(o)
    o.class == self.class && o.state == state
  end

  protected
  def state
    [@sender, @relay, @originating_txt, @arguments, @application_url]
  end
end
