Rails.application.routes.draw do
  apipie

  scope '/api' do
    use_doorkeeper do
      skip_controllers :applications, :authorized_applications
    end

    namespace :v1 do
      get '/users/me' => 'current_user#show'
      resources :users, except: %i(new edit create destroy)
      resources :support_schedules, except: %i(new edit)
      resources :swapped_schedules, only: %i(index create show update destroy)
      resources :undoable_schedules, only: %i(index create show update destroy)
    end
  end
end
