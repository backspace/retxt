require_relative 'abstract_command'

class Unvoice < AbstractCommand
  def execute
    ModifySubscription.new(context, success_response: SubscriptionModificationNotification.new(context, 'unvoice'), modifier: modifier).execute
  end

  private
  def modifier
    lambda do |subscription|
      subscription.unvoice
    end
  end
end
