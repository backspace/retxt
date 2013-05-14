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
      if target_relay.closed
        @admin_destinations = target_relay_admins.map(&:number)
        render_xml_template 'bounce_subscription'
      elsif subscriber.present?
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
        render_simple_response I18n.t('txts.create', relay_name: @relay.name)
      else
        render_simple_response 'you are not an admin'
      end
    elsif command == '/freeze'
      Freeze.new(sender: subscriber, relay: target_relay).execute
      render nothing: true
    elsif command == '/thaw' || command == '/unthaw'
      Thaw.new(sender: subscriber, relay: target_relay).execute
      render nothing: true
    elsif command == '/who'
      if subscriber.admin?
        @subscribers = target_relay.subscriptions.map(&:subscriber)
        render_xml_template 'who'
      else
        render_simple_response 'you are not an admin'
      end
    elsif command == '/mute'
      if subscriber.admin?
        @mutee = FindsSubscribers.find(after_command)

        if @mutee.present?
          subscription = Subscription.where(subscriber: @mutee, relay: target_relay).first

          if subscription.present?
            subscription.update_attribute(:muted, true)

            render_xml_template 'muted'
          end
        end
      end
    elsif command == '/unmute'
      if subscriber.admin?
        @unmutee = FindsSubscribers.find(after_command)

        if @unmutee.present?
          subscription = Subscription.where(subscriber: @unmutee, relay: target_relay).first

          if subscription.present?
            subscription.update_attribute(:muted, false)

            render_xml_template 'unmuted'
          end
        end
      end
    elsif command == '/close'
      Close.new(sender: subscriber, relay: target_relay).execute
      render nothing: true
    elsif command == '/open'
      Open.new(sender: subscriber, relay: target_relay).execute
      render nothing: true
    elsif command == '/rename'
      if subscriber.admin?
        target_relay.update_attribute(:name, after_command)
        render_xml_template 'renamed'
      end
    elsif command == '/clear'
      if subscriber.admin?
        target_relay.subscriptions.reject{|subscription| subscription.subscriber == subscriber}.each(&:destroy)
        render_xml_template 'cleared'
      end
    elsif command == '/delete'
      if subscriber.admin?
        DeletesRelays.delete_relay(subscriber: subscriber, relay: target_relay, substitute_relay_number: another_relay.number)
        render nothing: true
      end
    elsif command.starts_with? '/'
      render_xml_template 'unknown_command'
    elsif command.starts_with? '@'
      if subscriber.present?
        if command == '@anon'
          render_xml_template 'failed_direct_message'
        elsif subscriber.anonymous?
          render_xml_template 'forbid_anon_direct_message'
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
    @subscriber_count = target_relay.subscriptions.count - 1
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
        render_simple_response I18n.t('txts.frozen')
      elsif Subscription.find_by(subscriber: subscriber, relay: target_relay).muted
        @mutee = subscriber
        @original_message = params[:Body]
        @admin_destinations = target_relay_admins.map(&:number)
        render_xml_template 'muted_relay_fail'
      else
        @destinations = target_relay.subscriptions.map(&:subscriber).map(&:number) - [Subscriber.find_by(number: params[:From]).number]

        @destinations.each do |destination|
          SendsTxts.send_txt(to: destination, from: target_relay.number, body: "#{@subscriber.addressable_name} sez: #{params[:Body]}".truncate(160))
        end

        SendsTxts.send_txt(to: subscriber.number, from: target_relay.number, body: I18n.t('txts.relayed', subscriber_count: I18n.t('subscribers', count: @destinations.size)))

        render nothing: true
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

  def target_relay_admins
    target_relay.subscriptions.map(&:subscriber).select(&:admin)
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
    text_partial_to_string('commands_content', subscriber_count: (Subscriber.count - 1))
  end

  def text_partial_to_string(partial_name, locals = {})
    render_to_string partial: partial_name, formats: [:text], locals: locals
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

  def another_relay
    (Relay.all - [target_relay]).first
  end
end
