class Api::UsersResetPasswordRequestsController < Api::BaseController
  def create
    user_id = params[:user_id]
    otp = params[:otp]
    # Validate the otp parameter
    if otp.blank?
      render json: { error: 'OTP is required' }, status: :bad_request
      return
    end
    user = UserService::Index.call(user_id: user_id)
    if user.nil?
      render json: { error: 'User not found' }, status: :not_found
    else
      begin
        reset_password_request = UserResetPasswordService.call(user_id: user_id, otp: otp)
        if reset_password_request.persisted?
          render json: { status: reset_password_request.status, reset_password_request: reset_password_request }, status: :ok
        else
          render json: { error: reset_password_request.errors.full_messages }, status: :unprocessable_entity
        end
      rescue => e
        # Handle unexpected server error
        render json: { error: 'An unexpected error occurred' }, status: :internal_server_error
      end
    end
  end
end
