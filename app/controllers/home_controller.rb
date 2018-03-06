class HomeController < ApplicationController
  before_filter :check_for_setup

  def index
    @relay = Relay.master
    @subscriber_count = 5
  end

  def spell
    @relay = Relay.master
    if params[:answer] != @relay.answer
      flash[:alert] = "Your entries were not recognised"
      redirect_to "/"
    end
  end

  def edit_spell
    @relay = Relay.master
    authorize! :edit, @relay
  end

  def save_spell
    @relay = Relay.master
    @relay.update!(relay_params)
    flash[:notice] = "Saved!"
    redirect_to "/edit_spell"
  end

  private
  def check_for_setup
    if User.empty?
      redirect_to new_user_registration_path
    elsif Subscriber.empty?
      redirect_to setup_path(:get_admin_number)
    end
  end

  def relay_params
    params.require(:relay).permit(:directions)
  end
end
