module V1
  class UserSupportSchedulesController < ApplicationController
    def index
      support_schedules = user.support_schedules
      render json: support_schedules, root: :support_schedules
    end

    protected

    def user
      @user ||= User.find(params[:user_id])
    end
  end
end
