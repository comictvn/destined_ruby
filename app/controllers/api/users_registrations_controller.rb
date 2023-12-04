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
  def register_with_phone
    begin
      user = UserService::Index.call(phone_number: params[:phone_number])
      if user.present?
        render json: { message: I18n.t('phone_login.registrations.phone_number_already_registered') }, status: :unprocessable_entity and return
      else
        encrypted_password = Devise::Encryptor.digest(User, params[:password])
        @user = User.new(name: params[:name], phone_number: params[:phone_number], encrypted_password: encrypted_password)
        if @user.save
          render json: { message: I18n.t('common.200') }, status: :ok and return
        else
          error_messages = @user.errors.messages
          render json: { error_messages: error_messages, message: I18n.t('phone_login.registrations.failed_to_sign_up') }, status: :unprocessable_entity
        end
      end
    rescue => e
      render json: { message: e.message }, status: :internal_server_error
    end
  end
  private
  def create_params
    params.require(:user).permit(:password, :password_confirmation, :phone_number, :firstname, :lastname, :dob,
                                 :gender, :email)
  end
end
