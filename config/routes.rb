Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:show, :update] do
        collection do
          post 'register'
          post 'confirm'
        end
      end
      resources :tests, only: [:update, :create]
      resources :tables, only: [:create]
      resources :matches, only: [:show, :update] do
        member do
          put 'update_result'
        end
      end
    end
  end
end
