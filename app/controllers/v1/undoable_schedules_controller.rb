module V1
  class UndoableSchedulesController < ApplicationController
    after_action :verify_authorized, only: %w(create destroy)

    def index
      undoable_schedules = UndoableSchedule.all
      render json: undoable_schedules
    end

    def create
      undoable_schedule = current_user.undoable_schedules.build(undoable_schedule_params).tap do |undoable|
        authorize(undoable)
        undoable.save
      end
      render json: undoable_schedule
    end

    def show
      render json: undoable_schedule
    end

    def destroy
      authorize(undoable_schedule)
      undoable_schedule.destroy
      render json: undoable_schedule
    end

    protected

    def undoable_schedule
      @undoable_schedule ||= UndoableSchedule.find(params[:id])
    end

    def undoable_schedule_params
      @undoable_schedule_params ||= params
        .require(:undoable_schedule)
        .permit(:date, :reason)
    end
  end
end
