module V1
  class UsersController < ApplicationController
    include HasScope

    has_scope :roles, type: :array

    def index
      users = apply_scopes(User.all)
      render json: users
    end

    def show
      render json: user
    end

    protected

    def user
      @user ||= User.find(params[:id])
    end
  end
end
