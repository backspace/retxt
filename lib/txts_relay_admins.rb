class TxtsRelayAdmins
  def self.txt_relay_admins(options)
    relay = options[:relay]
    body = options[:body]

    relay.admins.each do |admin|
      SendsTxts.send_txt(from: relay.number, to: admin.number, body: body, originating_txt_id: options[:originating_txt_id])
    end
  end
end
