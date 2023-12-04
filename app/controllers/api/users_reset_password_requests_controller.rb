class Api::UsersResetPasswordRequestsController < Api::BaseController
  def create
    user_id = params[:user_id]
    otp = params[:otp]
    user = UserService::Index.call(user_id: user_id)
    if user.nil?
      render json: { error: 'User not found' }, status: :not_found
    else
      reset_password_request = UserResetPasswordService.call(user_id: user_id, otp: otp)
      if reset_password_request.persisted?
        render json: { status: reset_password_request.status }, status: :ok
      else
        render json: { error: reset_password_request.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
end
