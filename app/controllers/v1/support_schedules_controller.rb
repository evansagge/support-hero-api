module V1
  class SupportSchedulesController < ApplicationController
    def index
      schedules = schedule_list.schedules
      render json: schedules
    end

    def show
      date = Chronic.parse(params[:id]).to_date
      schedule = Schedule.find(date)
      render json: schedule
    end

    protected

    def schedule_list
      @schedule_list ||= ScheduleList.new(schedule_start)
    end

    def schedule_start
      return Date.today unless params[:year] && params[:month]
      Date.new(params[:year].to_i, params[:month].to_i)
    end
  end
end

