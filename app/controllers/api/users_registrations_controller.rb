class Api::UsersRegistrationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:register]
  def register
    user_params = params.permit(:username, :email, :password)
    result = UserRegistrationService.new(user_params).register
    if result.success?
      render json: { status: 200, user: result.user }, status: :ok
    else
      render json: { error: result.error }, status: :bad_request
    end
  end
end
