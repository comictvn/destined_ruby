class Api::UsersRegistrationsController < Api::BaseController
  def create
    email = params[:email]
    password = params[:password]
    password_confirmation = params[:password_confirmation]
    if UserService.validate_email(email) && !UserService.email_registered?(email)
      if UserService.password_match?(password, password_confirmation)
        encrypted_password = UserService.encrypt_password(password)
        user = UserService.create_user(email, encrypted_password)
        UserMailer.confirmation_email(user).deliver_now
        render json: { status: 'Registration successful', email_sent: 'Confirmation email sent' }, status: :ok
      else
        render json: { status: 'Registration failed', error: 'Password and password confirmation do not match' }, status: :unprocessable_entity
      end
    else
      render json: { status: 'Registration failed', error: 'Invalid email or email already registered' }, status: :unprocessable_entity
    end
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end
end
