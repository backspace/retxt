class Name
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]

    @i18n = options[:i18n] || I18n
    @sends_txts = options[:sends_txts] || SendsTxts

    @new_name = options[:arguments]
  end

  def execute
    ChangesNames.change_name(@sender, @new_name)
    @sends_txts.send_txt(from: @relay.number, to: @sender.number, body: @i18n.t('txts.name', name: @sender.name_or_anon))
  end
end
