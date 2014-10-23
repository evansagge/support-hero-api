module V1
  class SwappedSchedulesController < ApplicationController
    def index
      swapped_schedules = SwappedSchedule.all
      render json: swapped_schedules
    end

    def create
      swapped_schedule = current_user.swapped_schedules.build(create_params)
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

    def create_params
      params.require(:swapped_schedule).permit(:date)
    end

    def update_params
      params.require(:swapped_schedule).permit(:approved)
    end
  end
end
