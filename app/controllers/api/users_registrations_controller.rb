class Api::UsersRegistrationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:register]
  def register
    user_params = params.permit(:email, :password, :password_confirmation)
    result = UserValidator.new(user_params).validate
    if result[:status] == :error
      render json: { error: result[:message] }, status: :bad_request
    else
      user = UserRegistrationService.new(user_params).register
      if user[:status] == :error
        render json: { error: user[:message] }, status: :bad_request
      else
        render json: { status: 200, message: 'Registration successful. Please confirm your email address.', user_id: user[:data].id, email: user[:data].email, status: 'unconfirmed' }, status: :ok
      end
    end
  end
end
