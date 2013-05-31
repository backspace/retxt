class Name
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]

    @new_name = options[:arguments]
  end

  def execute
    ChangesNames.change_name(@sender, @new_name)
    SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.name', name: @sender.name_or_anon))
  end
end
