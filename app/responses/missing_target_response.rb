class MissingTargetResponse < SimpleResponse
  private
  def template_name
    'admin.missing_target'
  end

  def template_parameters(recipient)
    {target: arguments}
  end
end
