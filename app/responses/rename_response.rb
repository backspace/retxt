class RenameResponse < SimpleResponse
  private
  def template_parameters(recipient)
    {relay_name: arguments}
  end
end
