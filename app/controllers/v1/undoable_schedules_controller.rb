module V1
  class UndoableSchedulesController < ApplicationController
    after_action :verify_authorized, only: %w(create destroy)

    has_scope :pending, type: :boolean

    def index
      undoable_schedules = apply_scopes(UndoableSchedule.all)
      render json: undoable_schedules
    end

    def create
      undoable_schedule = current_user.undoable_schedules.build(create_params)
      authorize(undoable_schedule)
      undoable_schedule.save

      render json: undoable_schedule
    end

    def show
      render json: undoable_schedule
    end

    def update
      authorize(undoable_schedule)
      undoable_schedule.update(update_params)
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

    def create_params
      params.require(:undoable_schedule).permit(:date, :reason)
    end

    def update_params
      params.require(:undoable_schedule).permit(:approved)
    end
  end
end
