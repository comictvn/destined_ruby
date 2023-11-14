class Api::UsersController < ApplicationController
  # Other methods...
  def register
    begin
      user_params = params.require(:user).permit(:email, :password, :password_confirmation)
      validate_user_params(user_params)
      user = UserRegistrationService.new(user_params).register
      UserMailer.confirmation_email(user).deliver_now
      render json: { message: 'Registration successful. Please confirm your email address.', user_id: user.id }, status: :ok
    rescue UserValidator::ValidationError => e
      render json: { error: e.message }, status: :bad_request
    rescue ActiveRecord::RecordNotUnique => e
      render json: { error: 'Email is already registered.' }, status: :conflict
    rescue => e
      render json: { error: 'Unexpected error occurred' }, status: :internal_server_error
    end
  end
  private
  def validate_user_params(user_params)
    raise UserValidator::ValidationError, 'The email is required.' if user_params[:email].blank?
    raise UserValidator::ValidationError, 'Invalid email format.' unless user_params[:email] =~ URI::MailTo::EMAIL_REGEXP
    raise UserValidator::ValidationError, 'The password is required.' if user_params[:password].blank?
    raise UserValidator::ValidationError, 'Password must be at least 8 characters.' if user_params[:password].length < 8
    raise UserValidator::ValidationError, 'Password confirmation does not match.' if user_params[:password] != user_params[:password_confirmation]
  end
end
