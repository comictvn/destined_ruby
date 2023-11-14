class Api::UsersRegistrationsController < Api::BaseController
  def create
    user_params = params.require(:user).permit(:email, :password, :password_confirmation)
    validation_result = UserService::Index.new(user_params).call
    if validation_result[:status] == :error
      render json: { error_messages: validation_result[:errors], message: I18n.t('email_login.registrations.failed_to_sign_up') },
             status: :unprocessable_entity and return
    end
    if User.exists?(email: user_params[:email])
      render json: { message: I18n.t('email_login.registrations.email_already_registered') },
             status: :unprocessable_entity and return
    end
    user = User.new(email: user_params[:email], password: user_params[:password], password_confirmation: user_params[:password_confirmation])
    if user.save
      Devise::Mailer.confirmation_instructions(user, user.confirmation_token).deliver_now
      render json: { message: I18n.t('email_login.registrations.successfully_registered'), user_id: user.id },
             status: :ok and return
    else
      render json: { message: I18n.t('email_login.registrations.failed_to_sign_up') },
             status: :unprocessable_entity
    end
  end
end
