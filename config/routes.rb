Rails.application.routes.draw do
  namespace :api, path: 'api' do
    resources :channels, only: [:index, :show, :destroy]
  end
end