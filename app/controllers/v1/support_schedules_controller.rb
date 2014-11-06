module V1
  class SupportSchedulesController < ApplicationController
    api :GET, 'v1/support_schedules', 'Fetch all support schedules'
    param :start_date, Date, desc: 'Filter support schedules starting from this date ' \
      '(default: beginning of current month)', allow_nil: true
    param :end_date, Date, desc: 'Filter support schedules up to this date ' \
      '(default: end of the same month as :start_date, or end of current month)', allow_nil: true
    param :user_id, String, desc: 'Filter support schedules by user ID'
    error code: 401, desc: 'Unauthorized'
    def index
      support_schedules = SupportSchedule.between(start_date, end_date, user)
      render json: support_schedules
    end

    api :GET, 'v1/support_schedules/:id', 'Fetch a specific support schedule'
    param :id, String, required: true
    error code: 401, desc: 'Unauthorized'
    error code: 404, desc: 'Not Found'
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
