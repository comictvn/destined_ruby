
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

    resources :verify_otp, only: [:create] do
    end

    resources :send_otp_codes, only: [:create] do
    end

    resources :users_phone_registrations, only: [:create] do
    end

    resources :users, only: %i[index show destroy] do
    end

    resources :design_files, only: [] do
      post 'group_color_styles', on: :member
    end
    # Added route from the patch
    patch '/api/layers/:layer_id/color-style', to: 'design_files#apply_color_style_to_layer'
    put 'design_files/:design_file_id/layers/:layer_id/color_styles/:color_style_id', to: 'design_files#apply_color_style_to_layer'
    get 'design_files/:design_file_id/color_styles', to: 'design_files#list_color_styles'
  end

  get '/health' => 'pages#health_check'
  get 'api-docs/v1/swagger.yaml' => 'swagger#yaml'
end
