require_relative 'abstract_command'

class Unmute < AbstractCommand
  def execute
    ModifySubscription.new(context, success_response: SubscriptionModificationNotification.new(context, 'unmute'), modifier: modifier).execute
  end

  private
  def modifier
    lambda do |subscription|
      subscription.unmute
    end
  end
end
