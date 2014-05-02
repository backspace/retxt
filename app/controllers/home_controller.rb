class HomeController < ApplicationController
  before_filter :check_for_setup

  def index
    @relay = Relay.master
    @subscriber_count = Subscriber.count
  end

  private
  def check_for_setup
    if User.empty?
      redirect_to new_user_registration_path
    elsif Subscriber.empty?
      redirect_to setup_path(:get_admin_number)
    end
  end
end
