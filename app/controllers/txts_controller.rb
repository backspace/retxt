class TxtsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def incoming
    if command == 'help'
      help
    elsif command == 'subscribe'
      if Subscriber.where(number: params[:From]).present?
        already_subscribed
      else
        Subscriber.create(number: params[:From])
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
    render_simple_response 'help message'
  end

  def welcome
    render_simple_response "welcome to the relay. commands: help, unsubscribe. any other messages will be forwarded to #{ActionController::Base.helpers.pluralize Subscriber.count - 1, 'subscriber'}."
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
    Subscriber.where(number: params[:From]).first
  end

  def command
    params[:Body].split.first.downcase
  end
end
