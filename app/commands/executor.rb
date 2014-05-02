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
    txt.body[command.length + 1..-1] || ""
  end

  def subscriber
    Subscriber.find_or_create_by(number: @txt.from)
  end

  def target_relay
    Relay.find_or_create_by(number: @txt.to)
  end

  def execute
    if command == 'help' || command == 'about'
      Help.new(sender: subscriber, relay: target_relay).execute
    elsif command == 'name'
      Name.new(sender: subscriber, relay: target_relay, arguments: after_command.parameterize).execute
    elsif command == 'subscribe'
      Subscribe.new(relay: target_relay, sender: subscriber, arguments: after_command).execute
    elsif command == 'unsubscribe'
      Unsubscribe.new(relay: target_relay, sender: subscriber).execute
    elsif command == '/create'
      Create.new(relay: target_relay, sender: subscriber, application_url: @context[:application_url], arguments: after_command).execute
    elsif command == '/moderate'
      Moderate.new(relay: target_relay, sender: subscriber).execute
    elsif command == '/unmoderate'
      Unmoderate.new(relay: target_relay, sender: subscriber).execute
    elsif command == '/freeze'
      Freeze.new(sender: subscriber, relay: target_relay).execute
    elsif command == '/thaw' || command == '/unthaw'
      Thaw.new(sender: subscriber, relay: target_relay).execute
    elsif command == '/who'
      Who.new(sender: subscriber, relay: target_relay).execute
    elsif command == '/mute'
      Mute.new(sender: subscriber, relay: target_relay, arguments: after_command).execute
    elsif command == '/unmute'
      Unmute.new(sender: subscriber, relay: target_relay, arguments: after_command).execute
    elsif command == '/voice'
      Voice.new(sender: subscriber, relay: target_relay, arguments: after_command).execute
    elsif command == '/unvoice'
      Unvoice.new(sender: subscriber, relay: target_relay, arguments: after_command).execute
    elsif command == '/admin'
      Admin.new(sender: subscriber, relay: target_relay, arguments: after_command).execute
    elsif command == '/unadmin'
      Unadmin.new(sender: subscriber, relay: target_relay, arguments: after_command).execute
    elsif command == '/close'
      Close.new(sender: subscriber, relay: target_relay).execute
    elsif command == '/open'
      Open.new(sender: subscriber, relay: target_relay).execute
    elsif command == '/rename'
      Rename.new(sender: subscriber, relay: target_relay, arguments: after_command).execute
    elsif command == '/clear'
      Clear.new(sender: subscriber, relay: target_relay).execute
    elsif command == '/delete'
      Delete.new(sender: subscriber, relay: target_relay).execute
    elsif command == '/timestamp'
      Timestamp.new(sender: subscriber, relay: target_relay, arguments: after_command).execute
    elsif command.start_with? '/'
      Unknown.new(sender: subscriber, relay: target_relay).execute
    elsif command.start_with? '@'
      DirectMessage.new(sender: subscriber, relay: target_relay, txt: @txt).execute
    else
      RelayCommand.new(sender: subscriber, relay: target_relay, txt: @txt).execute
    end
  end
end
