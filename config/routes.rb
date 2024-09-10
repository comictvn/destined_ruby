Rails.application.routes.draw do
  namespace :api, path: 'api' do
    namespace :channels do
      resources :messages, only: [:index, :destroy]
    end
  end
end