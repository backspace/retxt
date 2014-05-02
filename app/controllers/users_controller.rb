class UsersController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def update
    @user.admin = params[:admin]
    @user.save

    render nothing: true
  end
end
