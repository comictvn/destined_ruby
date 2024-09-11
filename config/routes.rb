Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :channels do
      resources :messages, only: [:index, :destroy]
    end
  end
end