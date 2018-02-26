class AbstractCommand
  def initialize(command_context)
    @context = command_context
  end

  protected
  def context
    @context
  end

  def sender
    @context.sender
  end

  def relay
    @context.relay
  end

  def arguments
    @context.arguments
  end

  def application_url
    @context.application_url
  end

  def meeting
    @context.meeting
  end
end
