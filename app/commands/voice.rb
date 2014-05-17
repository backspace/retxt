require_relative 'abstract_command'

class Voice < AbstractCommand
  def execute
    ModifySubscription.new(context, success_response: SubscriptionModificationNotification.new(context, 'voice'), modifier: modifier).execute
  end

  private
  def modifier
    lambda do |subscription|
      subscription.voice
    end
  end
end
