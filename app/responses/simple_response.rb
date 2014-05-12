class SimpleResponse
  def initialize(command_context)
    @context = command_context
  end

  def deliver(recipient)
    SendsTxts.send_txt(
      from: @context.relay.number,
      to: recipient.number,
      body: I18n.t("txts.#{template_name}", template_parameters(recipient).merge(locale: recipient.locale)),
      originating_txt_id: @context.originating_txt_id
    )
  end

  private
  def template_name
    self.class.name.underscore.gsub "_response", ""
  end

  def template_parameters(recipient)
    {}
  end
end
