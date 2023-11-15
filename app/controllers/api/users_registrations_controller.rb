class Api::UsersRegistrationsController < Api::BaseController
  def register
    user_params = params.require(:user).permit(:username, :email, :password, :password_confirmation)
    begin
      validation_result = UserService::Index.validate_registration_data(user_params)
      if validation_result[:status] == :error
        render json: { error_messages: validation_result[:errors], message: I18n.t('email_login.registrations.failed_to_sign_up') },
               status: :bad_request and return
      end
      user = UserService::Create.new(user_params).call
      if user.persisted?
        UserMailer.confirmation_email(user).deliver_later
        render json: { message: I18n.t('email_login.registrations.successful_sign_up'), status: 200, user: user }, status: :ok
      else
        render json: { message: user.errors.full_messages }, status: :unprocessable_entity
      end
    rescue StandardError => e
      render json: { message: e.message }, status: :unprocessable_entity
    end
  end
end
