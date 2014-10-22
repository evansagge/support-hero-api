module V1
  class SupportSchedulesController < ApplicationController
    def index
      support_schedules = support_schedule_list.all(user)
      render json: support_schedules
    end

    def show
      support_schedule = support_schedule_list.find_by_date(date)
      render json: support_schedule
    end

    protected

    def support_schedule_list
      @support_schedule_list ||= SupportScheduleList.new(support_month)
    end

    def support_month
      return Date.today unless params[:year] && params[:month]
      Date.new(params[:year].to_i, params[:month].to_i)
    end

    def user
      @user ||= User.find(params[:user_id]) if params[:user_id]
    end

    def date
      @date ||= Chronic.parse(params[:id]).to_date
    end
  end
end
