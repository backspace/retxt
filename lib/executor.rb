class Executor
  def initialize(txt, application_context = {})
    @txt = txt
    @context = application_context
  end

  def txt
    @txt
  end

  def command
    txt.body.split.first.downcase
  end

  def after_command
    txt.body[command.length + 1..-1] || nil
  end

  def subscriber
    Subscriber.find_or_create_by(number: @txt.from)
  end

  def target_relay
    Relay.find_or_create_by(number: @txt.to)
  end

  def command_context
    @command_context ||= CommandContext.new(sender: subscriber, relay: target_relay, originating_txt: txt, arguments: after_command)
  end

  def execute
    parser = ParsesCommands.new(command, command_context)
    command_class = parser.parse
    command_context.locale = parser.locale
    command_class.new(command_context).execute
  end
end
