module V1
  class CurrentUserController < ApplicationController
    def show
      render json: current_user, root: :current_user
    end
  end
end
