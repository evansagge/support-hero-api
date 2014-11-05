module V1
  class SupportSchedulesController < ApplicationController
    swagger_controller :support_schedules, 'Support Schedules'

    swagger_api :index do
      summary 'Fetches all support schedules'
      param :query, :user_id, :string, :optional, 'Filter schedules by user'
      param :query, :start_date, :date, :optional, 'Filter schedules from start date (default: start of current month)'
      param :query, :end_date, :date, :optional, 'Filter schedules up to end date (default: end of month of :start_date, ' \
        'or end of current month)'
      response :unauthorized
    end

    swagger_api :show do
      summary 'Fetch a single support schedule'
      param :path, :id, :string, 'Date of the support schedule'
      response :success, 'Success', :support_schedule
      response :unauthorized
    end

    swagger_model :support_schedule do
      property :id, :string, :required, 'Date of support schedule'
      property :date, :date, :required, 'Date of support schedule'
      property :position, :integer, :required, 'Position in support order list'
      property :user_id, :string, :required, 'ID of user assigned for this support date'
      property :user_name, :string, :required, 'Name of user assigned for this support date'
    end

    def index
      support_schedules = SupportSchedule.between(start_date, end_date, user)
      render json: support_schedules
    end


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
