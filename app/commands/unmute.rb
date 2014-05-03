class Unmute
  def initialize(command_context)
    @command_context = command_context
    @sender = command_context.sender
    @relay = command_context.relay

    @arguments = command_context.arguments
  end

  def execute
    ModifySubscription.new(@command_context, success_message: I18n.t('txts.unmute', unmutee_name: @arguments, admin_name: @sender.addressable_name), modifier: modifier).execute
  end

  private
  def modifier
    lambda do |subscription|
      subscription.unmute!
    end
  end
end
