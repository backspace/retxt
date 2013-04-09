class TxtsController < ApplicationController
  skip_before_filter :verify_authenticity_token

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
        render_simple_response 'goodbye'
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
    # render_simple_response render_to_string(partial: 'welcome', formats: [:text], locals: {subscriber_count: Subscriber.count - 1, nick: subscriber.nick_or_anon})
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
end
