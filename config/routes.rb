Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :tests, only: [:update, :create]
      put '/shop/:id', to: 'shops#update'
    end
  end
end
