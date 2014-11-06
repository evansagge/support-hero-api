module V1
  class SwappedSchedulesController < ApplicationController
    has_scope :original_user
    has_scope :target_user
    has_scope :pending, type: :boolean
    has_scope :accepted, type: :boolean
    has_scope :rejected, type: :boolean

    api :GET, 'v1/swapped_schedules', 'Fetch all schedule swap requests'
    param :original_user, String, 'Filter by original user ID'
    param :target_user, String, 'Filter by target user ID'
    param :pending, [true, false], 'Return only pending schedule swaps'
    param :accepted, [true, false], 'Return only accepted schedule swaps'
    param :rejected, [true, false], 'Return only rejected schedule swaps'
    error code: 401, desc: 'Unauthorized'
    def index
      swapped_schedules = apply_scopes(SwappedSchedule.all)
      render json: swapped_schedules
    end

    api :POST, 'v1/swapped_schedules', 'Create a schedule swap request'
    param :swapped_schedule, Hash, required: true do
      param :original_date, Date, desc: 'Original date to swap', required: true
      param :target_date, Date, desc: 'Target date to swap', required: true
    end
    error code: 401, desc: 'Unauthorized'
    error code: 403, desc: 'Forbidden'
    def create
      swapped_schedule = SwappedSchedule.where(create_params).first_or_initialize
      authorize(swapped_schedule)
      swapped_schedule.save

      render json: swapped_schedule
    end

    api :GET, 'v1/swapped_schedules/:id', 'Fetch a specific schedule swap request'
    param :id, String, required: true
    error code: 401, desc: 'Unauthorized'
    error code: 404, desc: 'Not Found'
    def show
      render json: swapped_schedule
    end

    api :PUT, 'v1/swapped_schedules/:id', 'Update a specific schedule swap request'
    param :id, String, required: true
    param :swapped_schedule, Hash, required: true do
      param :status, %w(accepted rejected)
    end
    error code: 401, desc: 'Unauthorized'
    error code: 403, desc: 'Forbidden'
    error code: 404, desc: 'Not Found'
    def update
      authorize(swapped_schedule)
      swapped_schedule.update(update_params)

      render json: swapped_schedule
    end

    api :DELETE, 'v1/swapped_schedules/:id', 'Delete a specific schedule swap request'
    param :id, String, required: true
    error code: 401, desc: 'Unauthorized'
    error code: 403, desc: 'Forbidden'
    error code: 404, desc: 'Not Found'
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
