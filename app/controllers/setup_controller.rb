class SetupController < ApplicationController
  include Wicked::Wizard

  steps :get_admin_number, :buy_relay_number

  def show
    case step
    when :get_admin_number
      current_user.update_attribute(:admin, true)
      @subscriber = Subscriber.new
    when :buy_relay_number
      Create.new(relay: Relay.new(number: Subscriber.first.number), sender: Subscriber.first, application_url: incoming_txts_url, arguments: "B").execute
      @relay = Relay.first
    end

    render_wizard
  end

  def update
    case step
    when :get_admin_number
      @subscriber = Subscriber.new(subscriber_params)
      @subscriber.admin = true
      @subscriber.save
    end

    render_wizard @subscriber
  end

  private
  def subscriber_params
    params.require(:subscriber).permit(:number)
  end
end
