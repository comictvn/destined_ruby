class Api::UsersController < ApplicationController
  # Other methods...
  def register
    begin
      user_params = params.require(:user).permit(:username, :email, :password, :password_confirmation)
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
  def confirm_email
    begin
      user = User.find(params[:user_id])
      if user.confirmation_code == params[:confirmation_code]
        user.status = "confirmed"
        user.save!
        render json: { message: 'Email confirmed successfully' }, status: :ok
      else
        render json: { error: 'Invalid confirmation code' }, status: :bad_request
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found' }, status: :not_found
    rescue => e
      render json: { error: 'Unexpected error occurred' }, status: :internal_server_error
    end
  end
  private
  def validate_user_params(user_params)
    raise UserValidator::ValidationError, 'The username is required.' if user_params[:username].blank?
    raise UserValidator::ValidationError, 'You cannot input more 50 characters.' if user_params[:username].length > 50
    raise UserValidator::ValidationError, 'The password is required.' if user_params[:password].blank?
    raise UserValidator::ValidationError, 'Password must be at least 8 characters.' if user_params[:password].length < 8
    raise UserValidator::ValidationError, 'The email is required.' if user_params[:email].blank?
    raise UserValidator::ValidationError, 'Invalid email format.' unless user_params[:email] =~ URI::MailTo::EMAIL_REGEXP
    raise UserValidator::ValidationError, 'Password confirmation does not match.' if user_params[:password] != user_params[:password_confirmation]
  end
end
