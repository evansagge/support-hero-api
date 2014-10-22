Rails.application.routes.draw do
  namespace :v1 do
    resources :support_schedules, except: %i(new edit)
    resources :users, except: %i(new edit) do
      resources :support_schedules, only: :index
    end
  end
end
