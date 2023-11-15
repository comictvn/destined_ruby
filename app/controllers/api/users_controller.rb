class Api::UsersController < ApplicationController
  # Other methods...
  def register
    begin
      user_params = params.require(:user).permit(:name, :email, :password)
      validate_user_params(user_params)
      user = UserRegistrationService.new(user_params).register
      UserMailer.confirmation_email(user).deliver_now
      render json: UserSerializer.new(user).serialized_json, status: :ok
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
    raise UserValidator::ValidationError, 'The name is required.' if user_params[:name].blank?
    raise UserValidator::ValidationError, 'You cannot input more 50 characters.' if user_params[:name].length > 50
    raise UserValidator::ValidationError, 'The password is required.' if user_params[:password].blank?
    raise UserValidator::ValidationError, 'Password must be at least 8 characters.' if user_params[:password].length < 8
    raise UserValidator::ValidationError, 'The email is required.' if user_params[:email].blank?
    raise UserValidator::ValidationError, 'Wrong email format.' unless user_params[:email] =~ URI::MailTo::EMAIL_REGEXP
  end
end
