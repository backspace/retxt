class SubscribersController < ApplicationController
  load_and_authorize_resource

  def index
    @relays = Relay.all
  end
end
