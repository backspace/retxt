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
      if params[:relay][:number].present?
        @relay = Relay.create(relay_params)
        Subscription.create(relay: @relay, subscriber: Subscriber.first)

        context = creation_context
        context.relay = @relay
        CreationNotification.new(context).deliver @relay.admins

        model = @relay
      else
        context = creation_context
        context.relay = Relay.new(number: Subscriber.first.number)
        Create.new(context).execute
        @relay = Relay.first
        model = @relay
      end
    end

    render_wizard model
  end

  private
  def subscriber_params
    params.require(:subscriber).permit(:number, :name)
  end

  def relay_params
    params.require(:relay).permit(:name, :number)
  end

  def creation_context
    CommandContext.new(sender: Subscriber.first, application_url: incoming_txts_url, arguments: params[:relay][:name], originating_txt: OpenStruct.new(id: nil))
  end
end
