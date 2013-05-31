class Admin
  def initialize(options)
    @sender = options[:sender]
    @relay = options[:relay]

    @arguments = options[:arguments]
  end

  def execute
    if @sender.admin
      adminee = FindsSubscribers.find(@arguments)

      if adminee
        adminee.admin!

        TxtsRelayAdmins.txt_relay_admins(relay: @relay, body: I18n.t('txts.admin.admin', adminer_name: @sender.addressable_name, adminee_name: adminee.addressable_name))
      else
        SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.missing_target', target: @arguments))
      end
    else
      SendsTxts.send_txt(from: @relay.number, to: @sender.number, body: I18n.t('txts.nonadmin'))
    end
  end
end
