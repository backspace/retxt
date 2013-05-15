class Who
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]

    @i18n = options[:i18n] || I18n
    @sends_txts = options[:sends_txts] || SendsTxts

    @who_txt = options[:who_txt] || WhoResponse
  end

  def execute
    if @sender.admin
      txt = @who_txt.generate(relay: @relay)

      @sends_txts.send_txts(from: @relay.number, to: @sender.number, body: txt)
    else
      @sends_txts.send_txt(from: @relay.number, to: @sender.number, body: @i18n.t('txts.nonadmin'))
    end
  end
end
