class TxtsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :validate_twilio_request, only: :incoming if Rails.env.production?
  before_filter :reload_settings
  before_filter :store_incoming_message, only: :incoming

  helper_method :target_relay

  def incoming
    if command == 'help' || command == 'about'
      Help.new(sender: subscriber, relay: target_relay).execute
      render nothing: true
    elsif command == 'name'
      Name.new(sender: subscriber, relay: target_relay, arguments: after_command.parameterize).execute
      render nothing: true
    elsif command == 'subscribe'
      Subscribe.new(relay: target_relay, sender: subscriber || Subscriber.new(number: params[:From]), arguments: after_command).execute
      render nothing: true
    elsif command == 'unsubscribe'
      Unsubscribe.new(relay: target_relay, sender: subscriber || Subscriber.new(number: params[:From])).execute
      render nothing: true
    elsif command == 'create'
      Create.new(relay: target_relay, sender: subscriber, application_url: incoming_txts_url, arguments: after_command).execute
      render nothing: true
    elsif command == '/freeze'
      Freeze.new(sender: subscriber, relay: target_relay).execute
      render nothing: true
    elsif command == '/thaw' || command == '/unthaw'
      Thaw.new(sender: subscriber, relay: target_relay).execute
      render nothing: true
    elsif command == '/who'
      Who.new(sender: subscriber, relay: target_relay).execute
      render nothing: true
    elsif command == '/mute'
      Mute.new(sender: subscriber, relay: target_relay, arguments: after_command).execute
      render nothing: true
    elsif command == '/unmute'
      Unmute.new(sender: subscriber, relay: target_relay, arguments: after_command).execute
      render nothing: true
    elsif command == '/close'
      Close.new(sender: subscriber, relay: target_relay).execute
      render nothing: true
    elsif command == '/open'
      Open.new(sender: subscriber, relay: target_relay).execute
      render nothing: true
    elsif command == '/rename'
      Rename.new(sender: subscriber, relay: target_relay, arguments: after_command).execute
      render nothing: true
    elsif command == '/clear'
      Clear.new(sender: subscriber, relay: target_relay).execute
      render nothing: true
    elsif command == '/delete'
      Delete.new(sender: subscriber, relay: target_relay).execute
      render nothing: true
    elsif command.starts_with? '/'
      Unknown.new(sender: subscriber, relay: target_relay).execute
      render nothing: true
    elsif command.starts_with? '@'
      DirectMessage.new(sender: subscriber, relay: target_relay, content: params[:Body]).execute
      render nothing: true
    else
      RelayCommand.new(sender: subscriber || Subscriber.new(number: params[:From]), relay: target_relay, content: params[:Body]).execute
      render nothing: true
    end
  end

  private
  def subscriber
    @subscriber ||= Subscriber.where(number: params[:From]).first
  end

  def target_relay
    @relay ||= Relay.find_or_create_by(number: params[:To])
  end

  def command
    params[:Body].split.first.downcase
  end

  def after_command
    params[:Body][command.length + 1..-1] || ""
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
end
