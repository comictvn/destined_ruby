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

  resources :users, only: %i[index show] do
    post '/swipes', to: 'swipes#create'
    put '/profile', to: 'users#update_profile', on: :member
    put '/preferences', to: 'users#update_preferences', on: :member
    get '/matches', to: 'users#matches', on: :member
  end

  resources :conversations, only: [:create]

  # The new route for match_feedbacks create action is incorrect as per the requirement.
  # It should be '/match_feedback' instead of '/match_feedbacks'.
  # Correcting the route below:
  post '/match_feedback', to: 'match_feedbacks#create' # Corrected route as per requirement
end

get '/health' => 'pages#health_check'
get 'api-docs/v1/swagger.yaml' => 'swagger#yaml'
