class TxtsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :validate_twilio_request, only: :incoming if Rails.env.production?
  before_filter :reload_settings
  before_filter :store_incoming_message, only: :incoming

  helper_method :target_relay

  def index
    @subscriber = Subscriber.find(params[:subscriber_id])
    @txts = Txt.from(@subscriber.number)
  end

  def incoming
    Executor.new(@txt, application_context).execute
    render nothing: true
  end

  def trigger
    now = Time.now
    relay = Relay.first
    start = relay.start

    meetings = Meeting.where(messaged: false).select{|m| (start + m.offset.minutes) < now}

    meetings.each do |meeting|
      fake_context = CommandContext.new(relay: Relay.first, originating_txt: FakeTxt.new(''), meeting: meeting)

      meeting.teams.each do |team|
        team.subscribers.each do |subscriber|
          NotifyMeeting.new(fake_context).execute(meeting, subscriber)
        end
      end

      meeting.messaged = true
      meeting.save
    end

    broadcasts = Broadcast.where(messaged: false).select{|b| (start + b.offset.minutes) < now}

    broadcasts.each do |broadcast|
      relay.subscribers.each do |subscriber|
        SendsTxts.send_txt(
          from: relay.number,
          to: subscriber.number,
          body: broadcast.content
        )
      end

      broadcast.messaged = true
      broadcast.save
    end

    render nothing: true
  end

  private
  def validate_twilio_request
    # https://github.com/twilio/twilio-ruby/wiki/RequestValidator
    validator = Twilio::Security::RequestValidator.new(ENV['TWILIO_AUTH_TOKEN'])
    url = "#{request.protocol}#{request.host_with_port}#{request.fullpath}"
    parameters = env['rack.request.form_hash']
    signature = env['HTTP_X_TWILIO_SIGNATURE']


    validator.validate url, parameters, signature
  end

  def reload_settings
    RelaySettings.reload
  end

  def store_incoming_message
    @txt = Txt.create(from: params[:From], body: params[:Body].strip, to: params[:To], service_id: params[:SmsSid])
  end

  def application_context
    {application_url: incoming_txts_url}
  end
end

FakeTxt = Struct.new("FakeTxt", :id)
