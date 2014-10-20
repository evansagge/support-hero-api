module V1
  class UsersController < ApplicationController
    def index
      users = User.all
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

