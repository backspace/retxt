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
    if command == 'help' || command == 'about'
      Help.new(command_context).execute
    elsif command == 'name'
      Name.new(command_context).execute
    elsif command == 'subscribe'
      Subscribe.new(command_context).execute
    elsif command == 'unsubscribe'
      Unsubscribe.new(command_context).execute
    elsif command == '/create'
      Create.new(command_context).execute
    elsif command == '/moderate'
      Moderate.new(command_context).execute
    elsif command == '/unmoderate'
      Unmoderate.new(command_context).execute
    elsif command == '/freeze'
      Freeze.new(command_context).execute
    elsif command == '/thaw' || command == '/unthaw'
      Thaw.new(command_context).execute
    elsif command == '/who'
      Who.new(command_context).execute
    elsif command == '/mute'
      Mute.new(command_context).execute
    elsif command == '/unmute'
      Unmute.new(command_context).execute
    elsif command == '/voice'
      Voice.new(command_context).execute
    elsif command == '/unvoice'
      Unvoice.new(command_context).execute
    elsif command == '/admin'
      Admin.new(command_context).execute
    elsif command == '/unadmin'
      Unadmin.new(command_context).execute
    elsif command == '/close'
      Close.new(command_context).execute
    elsif command == '/open'
      Open.new(command_context).execute
    elsif command == '/rename'
      Rename.new(command_context).execute
    elsif command == '/clear'
      Clear.new(command_context).execute
    elsif command == '/delete'
      Delete.new(command_context).execute
    elsif command == '/timestamp'
      Timestamp.new(command_context).execute
    elsif command.start_with? '/'
      Unknown.new(command_context).execute
    elsif command.start_with? '@'
      DirectMessage.new(command_context).execute
    else
      RelayCommand.new(command_context).execute
    end
  end
end
