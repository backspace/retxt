class SimpleResponse
  def initialize(command_context)
    @context = command_context
  end

  def deliver(recipient)
    if recipient.is_a? Array
      recipient.each{|recipient| deliver(recipient) }
    else
      SendsTxts.send_txt(
        from: origin_of_txt,
        to: recipient.number,
        body: I18n.t("txts.#{template_name}", template_parameters(recipient).merge(locale: recipient.locale)),
        originating_txt_id: @context.originating_txt_id
      )
    end
  end

  protected
  def relay
    @context.relay
  end

  def sender
    @context.sender
  end

  def txt
    @context.txt
  end

  def arguments
    @context.arguments
  end

  def origin_of_txt
    relay.number
  end

  private
  def template_name
    admin_template_name || underscored_class_name.gsub("_response", "")
  end

  def admin_template_name
    "admin.#{underscored_class_name.gsub "_notification", ""}" if underscored_class_name.include? "_notification"
  end

  def underscored_class_name
    @underscored_class_name ||= self.class.name.underscore
  end

  def template_parameters(recipient)
    {}
  end
end
