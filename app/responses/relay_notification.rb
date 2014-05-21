class RelayNotification < SimpleResponse
  def deliver(recipients)
    recipients.each do |recipient|
      SendsTxts.send_txt(
        from: relay.number,
        to: recipient.number,
        body: RelayedTxtFormatter.new(relay: relay, sender: sender, recipient: recipient, txt: txt).format,
        originating_txt_id: @context.originating_txt_id
      )
    end
  end
end
