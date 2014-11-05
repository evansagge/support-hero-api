module V1
  class UsersController < ApplicationController
    include HasScope

    has_scope :roles, type: :array

    api :GET, 'v1/users', 'Fetch all users'
    param :roles, Array, desc: 'Filter users by roles (e.g. support, manager)'
    error code: 401, desc: 'Unauthorized'
    def index
      users = apply_scopes(User.all)
      render json: users
    end

    api :GET, 'v1/users/:id', 'Fetch a specific user'
    param :id, String, required: true
    error code: 401, desc: 'Unauthorized'
    def show
      render json: user
    end

    api :PUT, 'v1/users/:id', 'Update a specific user'
    param :user, Hash, required: true do
      param :password, String
      param :password_confirmation, String
    end
    error code: 401, desc: 'Unauthorized'
    error code: 403, desc: 'Forbidden'
    error code: 404, desc: 'Not Found'
    def update
      authorize(user)
      user.update(update_params)
      render json: user
    end

    protected

    def user
      @user ||= User.find(params[:id])
    end

    def update_params
      params.require(:user).permit(:password, :password_confirmation)
    end
  end
end
