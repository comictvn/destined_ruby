Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :channels, only: [:index, :show, :destroy]
  end
end