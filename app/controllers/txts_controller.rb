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
    render inline: "xml.Response { xml.Sms('help message') }", type: :builder
  end

  def welcome
    render inline: "xml.Response { xml.Sms('welcome') }", type: :builder
  end

  def already_subscribed
    render inline: "xml.Response { xml.Sms('you are already subscribed') }", type: :builder
  end

  def relay
    @destinations = (Subscriber.all - [Subscriber.find_by(number: params[:From])]).map(&:number)
    respond_to do |format|
      format.any do
        render 'relay', formats: :xml
      end
    end
  end
end
