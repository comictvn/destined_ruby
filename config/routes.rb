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
      resources :matches, only: [] do
        collection do
          get 'check_match_status/:id/:match_user_id', to: 'matches#check_match_status', as: 'check_match_status'
        end
      end
    end
  end
end
