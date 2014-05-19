require_relative 'abstract_command'

class Language < AbstractCommand
  def execute
    if relay.subscribed? sender
      if ChangesLanguages.new(sender, arguments).change_language
        LanguageResponse.new(context).deliver sender
      else
        LanguageBounceResponse.new(context).deliver sender
        LanguageBounceNotification.new(context).deliver relay.admins
      end
    else
      NotSubscribedCommandBounceResponse.new(context).deliver sender
      NotSubscribedCommandBounceNotification.new(context).deliver relay.admins
    end
  end
end
