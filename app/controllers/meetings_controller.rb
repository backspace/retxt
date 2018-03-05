class MeetingsController < ActionController::Base
  def show
    @meeting = Meeting.find(params[:id])

    @animated = params[:animated] != 'false'
  end
end
