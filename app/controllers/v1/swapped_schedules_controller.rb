module V1
  class SwappedSchedulesController < ApplicationController
    has_scope :original_user
    has_scope :target_user
    has_scope :pending, type: :boolean
    has_scope :accepted, type: :boolean
    has_scope :rejected, type: :boolean

    def index
      swapped_schedules = apply_scopes(SwappedSchedule.all)
      render json: swapped_schedules
    end

    def create
      swapped_schedule = SwappedSchedule.where(create_params).first_or_initialize
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
      params.require(:swapped_schedule).permit(:original_date, :target_date)
    end

    def update_params
      params.require(:swapped_schedule).permit(:status)
    end
  end
end
