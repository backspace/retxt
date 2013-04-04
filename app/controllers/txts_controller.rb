class TxtsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def incoming
    if params[:Body] == 'help'
      help
    elsif params[:Body] == 'subscribe'
      if Subscriber.where(number: params[:From]).present?
        already_subscribed
      else
        Subscriber.create(number: params[:From])
        welcome
      end
    else
      relay
    end
  end

  def help
    render_simple_response 'help message'
  end

  def welcome
    render_simple_response 'welcome'
  end

  def already_subscribed
    render_simple_response 'you are already subscribed'
  end

  def relay
    @destinations = (Subscriber.all - [Subscriber.find_by(number: params[:From])]).map(&:number)
    respond_to do |format|
      format.any do
        render 'relay', formats: :xml
      end
    end
  end

  private
  def render_simple_response(content)
    @content = content
    render 'simple_response', formats: :xml
  end
end
