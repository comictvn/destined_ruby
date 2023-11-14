Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :tests, only: [:update, :create]
    end
  end
end
