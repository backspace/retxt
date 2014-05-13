class MissingTargetResponse < SimpleResponse
  private
  def template_parameters(recipient)
    {target: arguments}
  end
end
