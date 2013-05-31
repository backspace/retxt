class Rename
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]

    @arguments = options[:arguments]
  end

  def execute
    if @sender.admin
      @relay.rename!(@arguments)
      SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.rename', relay_name: @arguments))
    else
      SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.nonadmin'))
    end
  end
end
