# FILE PATH: /app/controllers/api/sessions_controller.rb
class Api::SessionsController < ApplicationController
  require_dependency 'authentication_service'
  require_dependency 'token_generator'

  # POST /api/login
  def create
    username = params[:username]
    password = params[:password]

    if username.blank?
      render json: { error: 'Username is required.' }, status: :bad_request
      return
    end

    if password.blank?
      render json: { error: 'Password is required.' }, status: :bad_request
      return
    end

    begin
      authentication_service = AuthenticationService.new
      if authentication_service.authenticate(username, password)
        token = TokenGenerator.generate(access: :user, username: username)
        render json: { status: 200, message: 'Login successful.', access_token: token }, status: :ok
      else
        render json: { error: 'Invalid username or password.' }, status: :unauthorized
      end
    rescue Exceptions::AuthenticationError => e
      render json: { error: e.message }, status: :unauthorized
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
end
