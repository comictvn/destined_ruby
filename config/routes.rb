require 'sidekiq/web'

Rails.application.routes.draw do
  use_doorkeeper do
    controllers tokens: 'tokens'
    skip_controllers :authorizations, :applications, :authorized_applications
  end

  devise_for :users
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  
  namespace :v1 do
    resources :me, only: [:index] do
    end
  end

  namespace :api, defaults: { format: :json } do
    resources :force_update_app_versions, only: [:index] do
    end

    resources :users_verify_confirmation_token, only: [:create] do
    end

    resources :users_passwords, only: [:create] do
    end

    resources :users_registrations, only: [:create] do
    end

    resources :users_verify_reset_password_requests, only: [:create] do
    end

    resources :users_reset_password_requests, only: [:create] do
    end

    resources :messages, only: [:create] do
    end

    resources :chanels, only: %i[index show destroy] do
      resources :messages, only: %i[index destroy] do
      end
    end

    # Corrected the route for updating messages within a channel
    put '/chanels/:channel_id/messages/:id', to: 'messages#update'

    resources :verify_otp, only: [:create] do
    end

    resources :send_otp_codes, only: [:create] do
    end

    resources :users_phone_registrations, only: [:create] do
    end

    resources :users, only: %i[index show] do
    end

    # Added the manage articles route as per the requirement
    get '/articles/manage', to: 'articles#manage'

    # New route for saving article drafts
    post '/api/articles/drafts', to: 'articles#create_draft'

    resources :articles do
      resources :media, only: [:create]
      put ':id/publish', to: 'articles#publish', as: :publish_article
      # Updated the route for editing articles to match the requirement
      put ':id', to: 'articles#update'
      patch ':id', to: 'articles#update'
      delete ':id', to: 'articles#destroy'
      # New route for inserting media into an article as per the requirement
      post ':id/media', to: 'articles#insert_media'
    end
  end

  get '/health' => 'pages#health_check'
  get 'api-docs/v1/swagger.yaml' => 'swagger#yaml'
end
