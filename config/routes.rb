Rails.application.routes.draw do
  ...
  namespace :api, defaults: { format: :json } do
    ...
    resources :chanels, only: %i[index show destroy] do
      get 'messages', to: 'chanels#messages'
    end
    ...
  end
  ...
end
