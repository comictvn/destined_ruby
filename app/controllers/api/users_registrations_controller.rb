class Api::UsersRegistrationsController < Api::BaseController
  def create
    @user = User.new(create_params)
    if @user.save
      if Rails.env.staging?
        # to show token in staging
        token = @user.respond_to?(:confirmation_token) ? @user.confirmation_token : ''
        render json: { message: I18n.t('common.200'), token: token }, status: :ok and return
      else
        head :ok, message: I18n.t('common.200') and return
      end
    else
      error_messages = @user.errors.messages
      render json: { error_messages: error_messages, message: I18n.t('email_login.registrations.failed_to_sign_up') },
             status: :unprocessable_entity
    end
  end
  def register
    params.require(:user).permit(:email, :password)
    @user = User.new(email: params[:email], password: params[:password])
    if @user.save
      render json: { status: 200, message: 'Registration successful. Please check your email for verification link.' }, status: :ok
    else
      render json: { status: 500, message: 'An unexpected error occurred on the server.' }, status: :internal_server_error
    end
  end
  def create_params
    params.require(:user).permit(:password, :password_confirmation, :phone_number, :firstname, :lastname, :dob,
                                 :gender, :email)
  end
end
