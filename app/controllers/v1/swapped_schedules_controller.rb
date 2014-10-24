module V1
  class SwappedSchedulesController < ApplicationController
    def index
      swapped_schedules = SwappedSchedule.all
      render json: swapped_schedules
    end

    def create
      swapped_schedule = SupportScheduleSwapper.new(original_date, target_date)
      authorize(swapped_schedule)
      swapped_schedule.save

      render json: swapped_schedule
    end

    def show
      render json: swapped_schedule
    end

    def update
      authorize(swapped_schedule)
      swapped_schedule.update(update_params)

      render json: swapped_schedule
    end

    def destroy
      authorize(swapped_schedule)
      swapped_schedule.destroy

      render json: swapped_schedule
    end

    protected

    def swapped_schedule
      @swapped_schedule ||= SwappedSchedule.find(params[:id])
    end

    def original_date
      Chronic.parse(create_params.fetch(:original_date)).to_date
    end

    def target_date
      Chronic.parse(create_params.fetch(:target_date)).to_date
    end

    def create_params
      params.require(:swapped_schedule).permit(:original_date, :target_date)
    end

    def update_params
      params.require(:swapped_schedule).permit(:status)
    end
  end
end
