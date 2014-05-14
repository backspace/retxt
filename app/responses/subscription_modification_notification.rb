class SubscriptionModificationNotification < SimpleResponse
  def initialize(command_context, template_name)
    super(command_context)
    @template_name = template_name
  end

  private
  def template_name
    @template_name
  end

  def template_parameters(recipient)
    {admin_name: sender.addressable_name}.tap do |hash|
      hash[target_key] = arguments
    end
  end

  def target_key
    # FIXME temporary hack to turn 'voice' template into 'voicee_name' key
    "#{@template_name}e_name".to_sym
  end
end
