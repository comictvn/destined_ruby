class Api::UsersRegistrationsController < Api::BaseController
  def register
    user_params = params.require(:user).permit(:name, :email, :password, :password_confirmation)
    validation_result = UserService.validate(user_params)
    if validation_result[:status] == :error
      render json: { error_messages: validation_result[:errors], message: I18n.t('email_login.registrations.failed_to_sign_up') },
             status: :unprocessable_entity and return
    end
    if UserService.email_exists?(user_params[:email])
      render json: { message: I18n.t('email_login.registrations.email_already_registered') },
             status: :unprocessable_entity and return
    end
    encrypted_password = UserService.encrypt_password(user_params[:password])
    user = UserService.create_user(user_params[:name], user_params[:email], encrypted_password)
    if user
      TwilioGateway.send_confirmation_email(user_params[:email])
      render 'create.json.jbuilder', locals: { user: user }, status: :ok and return
    else
      render json: { message: I18n.t('email_login.registrations.failed_to_sign_up') },
             status: :unprocessable_entity
    end
  end
end
