Rails.application.routes.draw do
  namespace :api, path: 'api' do
    resources :channels, controller: 'channels', only: %i[index show destroy]
  end
end