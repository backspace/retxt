require_relative 'abstract_command'

class StartGetResponse < SimpleResponse
  private
  def template_parameters(recipient)
    {start_string: relay.start.strftime("%F %R")}
  end
end

class Start < AbstractCommand
  def execute
    if arguments.present?
      if sender.admin
        if arguments
          relay.start!(Time.zone.parse(arguments))
        end
        StartGetResponse.new(context).deliver relay.admins
      else
        NonAdminBounceResponse.new(context).deliver sender
        NonAdminBounceNotification.new(context).deliver relay.admins
      end
    else
      StartGetResponse.new(context).deliver sender
    end
  end
end
