class RenameResponse < SimpleResponse
  private
  def template_name
    'admin.rename'
  end

  def template_parameters(recipient)
    {relay_name: arguments}
  end
end
