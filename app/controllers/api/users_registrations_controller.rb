class Api::UsersRegistrationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:register]
  def register
    user_params = params.permit(:email, :password, :password_confirmation)
    result = UserValidator.new(user_params).validate
    if result[:status] == :error
      render json: { error: result[:message] }, status: :bad_request
    else
      user = User.find_by_email(user_params[:email])
      if user
        render json: { error: 'Email is already in use' }, status: :bad_request
      else
        user = User.new(user_params)
        user.password = Devise::Encryptor.digest(User, user_params[:password])
        if user.save
          UserMailer.confirmation_email(user).deliver_now
          render json: { status: 200, message: 'Registration successful. Please confirm your email address.', user_id: user.id }, status: :ok
        else
          render json: { error: 'Registration failed' }, status: :bad_request
        end
      end
    end
  end
end
