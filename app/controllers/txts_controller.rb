class TxtsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :validate_twilio_request, only: :incoming if Rails.env.production?

  def incoming
    if command == 'help' || command == 'about'
      help
    elsif command == 'nick'
      new_nick = params[:Body].split[1..-1].join(' ').parameterize

      if new_nick.present?
        subscriber.update_attribute(:nick, new_nick)
      end

      render_simple_response render_to_string(partial: 'nick', formats: [:text], locals: {nick: subscriber.nick_or_anon})
    elsif command == 'subscribe'
      if Subscriber.where(number: params[:From]).present?
        already_subscribed
      else
        @subscriber = Subscriber.create(number: params[:From])

        new_nick = params[:Body].split[1..-1].join(' ').parameterize

        @subscriber.update_attribute(:nick, new_nick) if new_nick.present?

        welcome
      end
    elsif command == 'unsubscribe'
      if subscriber.present?
        subscriber.destroy

        @unsubscriber = subscriber
        @admins = Subscriber.admins
        render 'goodbye_and_notification', formats: [:xml]
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
    @nick = subscriber.nick_or_anon
    @number = subscriber.number

    @admins = Subscriber.admins

    render 'welcome_and_notification', formats: [:xml]
  end

  def already_subscribed
    render_simple_response 'you are already subscribed'
  end

  def relay
    if subscriber.present?
      @destinations = (Subscriber.all - [Subscriber.find_by(number: params[:From])]).map(&:number)
      respond_to do |format|
        format.any do
          render 'relay', formats: :xml
        end
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

  def command
    params[:Body].split.first.downcase
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

    logger.info "validation data"
    logger.info "authtoken: #{ENV['TWILIO_AUTH_TOKEN']}"
    logger.info "url: #{url}"
    logger.info "params:"
    logger.info parameters
    logger.info "signature: #{signature}"

    logger.info "validator.validate: #{validator.validate url, parameters, signature}"


    validator.validate url, parameters, signature

    # Bypass authentication for now
    true
  end
end
