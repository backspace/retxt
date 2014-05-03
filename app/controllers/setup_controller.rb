class SetupController < ApplicationController
  include Wicked::Wizard

  steps :get_admin_number, :name_relay, :buy_relay_number

  def show
    case step
    when :get_admin_number
      current_user.update_attribute(:admin, true)
      @subscriber = Subscriber.new
    when :name_relay
      @relay = Relay.new
    when :buy_relay_number
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
      model = @subscriber
    when :name_relay
      Create.new(CommandContext.new(relay: Relay.new(number: Subscriber.first.number), sender: Subscriber.first, application_url: incoming_txts_url, arguments: params[:relay][:name], originating_txt: OpenStruct.new(id: nil))).execute
      model = Relay.first
    end

    render_wizard model
  end

  private
  def subscriber_params
    params.require(:subscriber).permit(:number, :name)
  end
end
