module V1
  class UndoableSchedulesController < ApplicationController
    after_action :verify_authorized, only: %w(create destroy)

    has_scope :pending, type: :boolean

    api :GET, 'v1/undoable_schedules', 'Fetch all undoable schedule requests'
    param :pending, [true, false], 'Return only pending undoable schedules'
    error code: 401, desc: 'Unauthorized'
    def index
      undoable_schedules = apply_scopes(UndoableSchedule.all)
      render json: undoable_schedules
    end

    api :POST, 'v1/undoable_schedules', 'Create an undoable schedule'
    param :undoable_schedule, Hash, required: true do
      param :date, Date, required: true
      param :reason, String, desc: 'The reason why this date is undoable', required: true
    end
    error code: 401, desc: 'Unauthorized'
    error code: 403, desc: 'Forbidden'
    def create
      undoable_schedule = current_user.undoable_schedules.build(create_params)
      authorize(undoable_schedule)
      undoable_schedule.save

      render json: undoable_schedule
    end

    api :GET, 'v1/undoable_schedules/:id', 'Fetch a specific undoable schedule request'
    param :id, String, required: true
    error code: 401, desc: 'Unauthorized'
    error code: 404, desc: 'Not Found'
    def show
      render json: undoable_schedule
    end

    api :PUT, 'v1/undoable_schedules/:id', 'Update a specific undoable schedule request'
    param :id, String, required: true
    param :undoable_schedule, Hash, required: true do
      param :approved, [true, false]
    end
    error code: 401, desc: 'Unauthorized'
    error code: 403, desc: 'Forbidden'
    error code: 404, desc: 'Not Found'
    def update
      authorize(undoable_schedule)
      undoable_schedule.update(update_params)
      render json: undoable_schedule
    end

    api :DELETE, 'v1/undoable_schedules/:id', 'Delete a specific undoable schedule request'
    param :id, String, required: true
    error code: 401, desc: 'Unauthorized'
    error code: 403, desc: 'Forbidden'
    error code: 404, desc: 'Not Found'
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
