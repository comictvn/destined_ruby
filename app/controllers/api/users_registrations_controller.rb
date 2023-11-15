class Api::UsersRegistrationsController < Api::BaseController
  def register
    begin
      user_params = params.require(:user).permit(:username, :email, :password)
      validation_result = UserService::Index.validate_registration_data(user_params)
      if validation_result[:status] == :error
        render json: { error_messages: validation_result[:errors], message: I18n.t('email_login.registrations.failed_to_sign_up') },
               status: :bad_request and return
      end
      user = UserService::Index.register(user_params)
      if user.persisted?
        render json: { status: 200, user: user }, status: :ok
      else
        render json: { message: I18n.t('email_login.registrations.failed_to_sign_up') },
               status: :internal_server_error
      end
    rescue => e
      render json: { message: I18n.t('email_login.registrations.failed_to_sign_up') },
             status: :internal_server_error
    end
  end
end
