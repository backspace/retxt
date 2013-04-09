class HomeController < ApplicationController
  def index
    @subscriber_count = Subscriber.count
  end
end
