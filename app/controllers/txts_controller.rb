class TxtsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def incoming
    render inline: "xml.Response { xml.Sms('help message') }", type: :builder
  end
end
