class MissingDirectMessageTargetBounceResponse < SimpleResponse
  private
  def template_name
    'direct.missing_target'
  end

  def template_parameters(recipient)
    {target_name: target_name}
  end

  def target_name
    # FIXME also duplicate of DirectMessage#target
    txt.body.split.first
  end
end
