module V1
  class CurrentUserController < ApplicationController
    api :GET, 'v1/users/me', 'Fetch the currently logged in user'
    error code: 401, desc: 'Unauthorized'
    def show
      render json: current_user, root: :user
    end
  end
end
