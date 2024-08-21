Rails.application.routes.draw do
  namespace :api do
    resources :chanels, only: [:index, :show, :destroy]
  end
end