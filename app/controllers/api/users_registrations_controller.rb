class Api::UsersRegistrationsController < Api::BaseController
  def create
    email = params[:email]
    password = params[:password]
    password_confirmation = params[:password_confirmation]
    if UserService.email_valid?(email) && !UserService.email_registered?(email)
      if UserService.passwords_match?(password, password_confirmation)
        encrypted_password = UserService.encrypt_password(password)
        user = UserService.create_user(email, encrypted_password)
        UserRegistrationService.send_confirmation_email(user)
        render json: { status: 'Registration successful', confirmation_email_sent: true }, status: :ok
      else
        render json: { status: 'Password and password confirmation do not match' }, status: :unprocessable_entity
      end
    else
      render json: { status: 'Email is invalid or already registered' }, status: :unprocessable_entity
    end
  end
end
