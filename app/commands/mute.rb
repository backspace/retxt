require_relative 'abstract_command'

class Mute < AbstractCommand
  def execute
    ModifySubscription.new(context, success_response: SubscriptionModificationNotification.new(context, 'mute'), modifier: modifier).execute
  end

  private
  def modifier
    lambda do |subscription|
      subscription.mute
    end
  end
end
