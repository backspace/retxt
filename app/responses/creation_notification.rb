class CreationNotification < SimpleResponse
  protected
  def origin_of_txt
    Relay.find_by(name: arguments).number
  end

  private
  def template_name
    'admin.create'
  end

  def template_parameters(recipient)
    {admin_name: sender.addressable_name, relay_name: arguments}
  end
end
