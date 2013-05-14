class ModifyRelay
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]

    @i18n = options[:i18n] || I18n
    @sends_txts = options[:sends_txts] || SendsTxts

    @modifier = options[:modifier]
    @success_message = options[:success_message]
  end

  def execute
    if @sender.admin
      @relay.send(@modifier)
      @sends_txts.send_txt(from: @relay.number, to: @sender.number, body: @success_message)
    else
      @sends_txts.send_txt(from: @relay.number, to: @sender.number, body: @i18n.t('txts.nonadmin'))
    end
  end
end
