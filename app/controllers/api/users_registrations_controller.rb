class Api::UsersRegistrationsController < Api::BaseController
  def register
    user_params = params.require(:user).permit(:name, :email, :password, :password_confirmation)
    validation_result = UserService::Index.new(user_params).validate
    if validation_result[:status] == :error
      render json: { error_messages: validation_result[:errors], message: I18n.t('email_login.registrations.failed_to_sign_up') },
             status: :unprocessable_entity and return
    end
    if User.find_by_email(user_params[:email])
      render json: { message: I18n.t('email_login.registrations.email_already_registered') },
             status: :unprocessable_entity and return
    end
    user_params[:password] = User.encrypt(user_params[:password])
    user = User.create(user_params)
    if user.persisted?
      Devise::Mailer.confirmation_instructions(user, user.confirmation_token).deliver_now
      render 'create.json.jbuilder', locals: { user: user }, status: :ok and return
    else
      render json: { message: I18n.t('email_login.registrations.failed_to_sign_up') },
             status: :unprocessable_entity
    end
  end
end
