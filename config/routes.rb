Rails.application.routes.draw do
  use_doorkeeper do
    skip_controllers :applications, :authorized_applications
  end

  namespace :v1 do
    resources :support_schedules, except: %i(new edit)
    resources :users, except: %i(new edit create destroy)
    resources :undoable_schedules, only: %i(index show create destroy)
  end
end
