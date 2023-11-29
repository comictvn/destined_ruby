class Api::UsersRegistrationsController < Api::BaseController
  def create
    begin
      user_params = create_params
      UserService::Index.new(user_params).validate!
      @user = User.new(user_params)
      @user.id = SecureRandom.uuid
      if @user.save
        render json: { user_id: @user.id }, status: :ok and return
      else
        error_messages = @user.errors.messages
        render json: { error_messages: error_messages, message: I18n.t('email_login.registrations.failed_to_sign_up') },
               status: :unprocessable_entity
      end
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
  def create_params
    params.require(:user).permit(:name, :age, :gender, :location, :interests, :preferences)
  end
end
