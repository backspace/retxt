class ParsesCommands
  def initialize(command, context)
    @command = command
    @context = context
  end

  def parse
    if command == 'help' || command == 'about'
      Help
    elsif command == 'name'
      Name
    elsif command == 'subscribe'
      Subscribe
    elsif command == 'unsubscribe'
      Unsubscribe
    elsif command == '/create'
      Create
    elsif command == '/moderate'
      Moderate
    elsif command == '/unmoderate'
      Unmoderate
    elsif command == '/freeze'
      Freeze
    elsif command == '/thaw' || command == '/unthaw'
      Thaw
    elsif command == '/who'
      Who
    elsif command == '/mute'
      Mute
    elsif command == '/unmute'
      Unmute
    elsif command == '/voice'
      Voice
    elsif command == '/unvoice'
      Unvoice
    elsif command == '/admin'
      Admin
    elsif command == '/unadmin'
      Unadmin
    elsif command == '/close'
      Close
    elsif command == '/open'
      Open
    elsif command == '/rename'
      Rename
    elsif command == '/clear'
      Clear
    elsif command == '/delete'
      Delete
    elsif command == '/timestamp'
      Timestamp
    elsif command.start_with? '/'
      Unknown
    elsif command.start_with? '@'
      DirectMessage
    else
      RelayCommand
    end
  end

  protected
  def command
    @command
  end
end
