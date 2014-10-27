module V1
  class SupportSchedulesController < ApplicationController
    def index
      support_schedules = SupportSchedule.between(start_date, end_date, user)
      render json: support_schedules
    end

    def show
      support_schedule = SupportSchedule.find(date)
      render json: support_schedule
    end

    protected

    def start_date
      @start_date ||= params[:start_date].blank? ? Date.today.beginning_of_month : Chronic.parse(params[:start_date]).to_date
    end

    def end_date
      @end_date ||=  params[:end_date].present? ? Chronic.parse(params[:end_date]).to_date : start_date.end_of_month
    end

    def user
      @user ||= User.find(params[:user_id]) if params[:user_id]
    end

    def date
      @date ||= Chronic.parse(params.fetch(:id)).to_date
    end
  end
end
