class TxtsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :validate_twilio_request, only: :incoming if Rails.env.production?
  before_filter :reload_settings
  before_filter :store_incoming_message, only: :incoming

  helper_method :target_relay

  def incoming
    if command == 'help' || command == 'about'
      help
    elsif command == 'name'
      new_name = after_command.parameterize

      ChangesNames.change_name(subscriber, new_name)

      render_simple_response render_to_string(partial: 'name', formats: [:text], locals: {name: subscriber.name_or_anon})
    elsif command == 'subscribe'
      if subscriber.present?
        if target_relay.subscribed?(subscriber)
          already_subscribed
        else
          Subscription.create(relay: target_relay, subscriber: subscriber)
          welcome
        end
      else
        @subscriber = Subscriber.create(number: params[:From])
        Subscription.create(subscriber: @subscriber, relay: target_relay)

        new_name = after_command.parameterize

        ChangesNames.change_name(@subscriber, new_name)

        welcome
      end
    elsif command == 'unsubscribe'
      if subscriber.present? && target_relay.subscribed?(subscriber)
        Subscription.find_by(relay: target_relay, subscriber: subscriber).destroy

        @unsubscriber = subscriber
        @admins = Subscriber.admins
        render 'goodbye_and_notification', formats: [:xml]
      else
        render_simple_response 'you are not subscribed'
      end
    elsif command == 'create'
      if subscriber.admin?
        @from = BuysNumbers.buy_number('514', incoming_txts_url)
        @relay = Relay.create(name: after_command, number: @from)
        Subscription.create(relay: @relay, subscriber: subscriber)
        render_simple_response "created a new relay! called #{@relay.name}"
      else
        render_simple_response 'you are not an admin'
      end
    elsif command == 'freeze'
      if subscriber.admin?
        target_relay.update_attribute(:frozen, true)
        render_simple_response 'the relay is now frozen'
      else
        render_simple_response 'you are not an admin'
      end
    elsif command == 'thaw' || command == 'unthaw'
      if subscriber.admin?
        target_relay.update_attribute(:frozen, false)
        render_simple_response 'the relay is thawed'
      else
        render_simple_response 'you are not an admin'
      end
    elsif command.starts_with? '@'
      if subscriber.present?
        if command == '@anon'
          render_xml_template 'failed_direct_message'
        else
          @subscriber = subscriber
          @recipient = Subscriber.where(name: command[1..-1]).first

          if @recipient.present?
            render_xml_template 'direct_message'
          else
            @recipient = command
            render_xml_template 'failed_direct_message'
          end
        end
      else
        render_simple_response 'you are not subscribed'
      end
    else
      relay
    end
  end

  def help
    render_simple_response commands_content
  end

  def welcome
    @subscriber_count = Subscriber.count - 1
    @name = subscriber.name_or_anon
    @number = subscriber.number

    @admins = Subscriber.admins

    render 'welcome_and_notification', formats: [:xml]
  end

  def already_subscribed
    render_simple_response 'you are already subscribed'
  end

  def relay
    if subscriber.present? && target_relay.subscribed?(subscriber)
      if target_relay.frozen
        render_simple_response 'the relay is frozen'
      else
        @destinations = target_relay.subscriptions.map(&:subscriber).map(&:number) - [Subscriber.find_by(number: params[:From]).number]
        render_xml_template 'relay'
      end
    else
      render_simple_response 'you are not subscribed'
    end
  end

  private
  def render_simple_response(content)
    @content = content
    render 'simple_response', formats: :xml
  end

  def subscriber
    @subscriber ||= Subscriber.where(number: params[:From]).first
  end

  def target_relay
    @relay ||= find_or_create_relay
  end

  def find_or_create_relay
    matching = Relay.where(number: params[:To]).first

    if matching.nil?
      relay = Relay.create(number: params[:To])
      Subscriber.all.each do |subscriber|
        relay.subscriptions << Subscription.create(subscriber: subscriber, relay: relay)
      end

      relay
    else
      matching
    end
  end

  def command
    params[:Body].split.first.downcase
  end

  def after_command
    params[:Body][command.length + 1..-1] || ""
  end

  def commands_content
    render_to_string partial: 'commands_content', formats: [:text], locals: {subscriber_count: (Subscriber.count - 1)}
  end

  def validate_twilio_request
    # https://github.com/twilio/twilio-ruby/wiki/RequestValidator
    validator = Twilio::Util::RequestValidator.new(ENV['TWILIO_AUTH_TOKEN'])
    url = "#{request.protocol}#{request.host_with_port}#{request.fullpath}"
    parameters = env['rack.request.form_hash']
    signature = env['HTTP_X_TWILIO_SIGNATURE']


    validator.validate url, parameters, signature
  end

  def reload_settings
    RelaySettings.reload
  end

  def store_incoming_message
    Txt.create(from: params[:From], body: params[:Body], to: params[:To], service_id: params[:SmsSid])
  end

  def render_xml_template(template_name)
    respond_to do |format|
      format.any do
        render template_name, formats: :xml
      end
    end
  end
end
