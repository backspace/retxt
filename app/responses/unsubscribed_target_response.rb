class UnsubscribedTargetResponse < SimpleResponse
  private
  def template_parameters
    {target: arguments}
  end
end
