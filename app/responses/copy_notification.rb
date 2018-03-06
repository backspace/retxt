class CopyNotification < SimpleResponse
  def initialize(command_context, prefix)
    @context = command_context
    @prefix = prefix
  end

  private
  def template_parameters(recipient)
    {sender: sender.addressable_name, txt: txt.body, prefix: @prefix}
  end
end
