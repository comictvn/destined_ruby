class Api::UsersVerifyResetPasswordRequestsController < Api::BaseController
  def create
    token = Devise.token_generator.digest(User, :reset_password_token, params.dig(:reset_token))
    @user = User.find_by(reset_password_token: token)
    if @user.blank? || params.dig(:reset_token).blank? || params.dig(:password).blank? || params.dig(:password_confirmation).blank?
      @error_message = I18n.t('reset_password.invalid_token')
    elsif !@user.reset_password_period_valid?
      @error_message = I18n.t('errors.messages.expired')
    elsif @user.reset_password(params.dig(:password), params.dig(:password), params.dig(:password_confirmation))
    else
      @error_message = @user.errors.full_messages
    end
    if @error_message.present?
      render json: { error_message: @error_message }, status: :unprocessable_entity
    else
      head :ok, message: I18n.t('common.200')
    end
  end
  def verify
    begin
      id = params[:id]
      if id.blank? || !(id.is_a? Integer)
        render json: { error_message: "Wrong format" }, status: :bad_request
      else
        password_reset_request = PasswordResetRequest.find_by(id: id)
        if password_reset_request.nil?
          render json: { error_message: "This request is not found" }, status: :bad_request
        elsif password_reset_request.status != 'verified'
          password_reset_request.update(status: 'verified')
          render json: { message: "The reset password request was successfully verified." }, status: :ok
        end
      end
    rescue => e
      render json: { error_message: e.message }, status: :internal_server_error
    end
  end
end
