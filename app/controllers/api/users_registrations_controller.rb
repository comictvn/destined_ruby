class Api::UsersRegistrationsController < Api::BaseController
  def create
    @user = User.new(create_params)
    if @user.save
      token = @user.respond_to?(:confirmation_token) ? @user.confirmation_token : ''
      Devise::Mailer.confirmation_instructions(@user, token).deliver_now
      render json: { status: 200, user: { id: @user.id, username: @user.username, email: @user.email } }, status: :ok
    else
      error_messages = @user.errors.messages
      render json: { error_messages: error_messages, message: I18n.t('email_login.registrations.failed_to_sign_up') },
             status: :unprocessable_entity
    end
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end
  private
  def create_params
    params.require(:user).permit(:username, :email, :password)
  end
end
