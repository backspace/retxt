class ForbiddenAnonymousDirectMessageBounceResponse < SimpleResponse
  private
  def template_name
    'direct.anonymous'
  end
end
