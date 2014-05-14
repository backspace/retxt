class RelayModificationNotification < SimpleResponse
  def initialize(command_context, template_name)
    super(command_context)
    @template_name = template_name
  end

  private
  def template_name
    "admin.#{@template_name}"
  end

  def template_parameters(recipient)
    {admin_name: sender.addressable_name}
  end
end
