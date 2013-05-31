class Unadmin
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]

    @arguments = options[:arguments]
  end

  def execute
    if @sender.admin
      unadminee = FindsSubscribers.find(@arguments)

      if unadminee
        unadminee.unadmin!

        TxtsRelayAdmins.txt_relay_admins(relay: @relay, body: I18n.t('txts.admin.unadmin', unadminer_name: @sender.addressable_name, unadminee_name: unadminee.addressable_name))
      else
        SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.missing_target', target: @arguments))
      end
    else
      SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.nonadmin'))
    end
  end
end
