class TxtsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def incoming
    if params[:Body] == 'help'
      help
    elsif params[:Body] == 'subscribe'
      Subscriber.create(number: params[:From])
      welcome
    end
  end

  def help
    render inline: "xml.Response { xml.Sms('help message') }", type: :builder
  end

  def welcome
    render inline: "xml.Response { xml.Sms('welcome') }", type: :builder
  end
end
