class NameResponse < SimpleResponse
  private
  def template_parameters(recipient)
    {name: sender.name_or_anon}
  end
end
