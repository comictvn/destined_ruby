Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:show, :update]
      resources :tests, only: [:update, :create]
    end
  end
end
