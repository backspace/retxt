class HomeController < ApplicationController
  def index
    @relay = Relay.master
    @subscriber_count = Subscriber.count
  end
end
