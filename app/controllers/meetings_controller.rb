class MeetingsController < ActionController::Base
  def show
    @meeting = Meeting.find(params[:id])
  end
end
