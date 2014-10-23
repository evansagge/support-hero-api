module V1
  class UndoableSchedulesController < ApplicationController
    def index
      undoable_schedules = UndoableSchedule.all
      render json: undoable_schedules
    end

    def create
      undoable_schedule = current_user.undoable_schedules.create(undoable_schedule_params)
      render json: undoable_schedule
    end

    def show
      render json: undoable_schedule
    end

    def destroy
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
