class Api::UsersVerifyResetPasswordRequestsController < Api::BaseController
  def create
    begin
      result = ResetPasswordService.verifyResetPasswordRequest(params[:id], params[:otp])
      if result[:status] == 'success'
        render json: { message: 'OTP verified successfully', status: result[:status], reset_password_request: result[:reset_password_request] }, status: :ok
      else
        render json: { error_message: result[:message] }, status: :bad_request
      end
    rescue => e
      render json: { error_message: e.message }, status: :internal_server_error
    end
  end
end
