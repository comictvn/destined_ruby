class Api::VerifyOtpController < Api::BaseController
  before_action :authenticate_user!
  before_action :authorize_user!
  def create
    phone_number = params[:phone_number]
    otp_code = params[:otp_code]
    if phone_number.blank? || otp_code.blank?
      render json: { error: 'Phone number and OTP code are required.' }, status: :unprocessable_entity
      return
    end
    if phone_number.is_a?(String) && otp_code.is_a?(String)
      begin
        PhoneVerification.verify(phone_number, otp_code)
        render json: { message: 'OTP verification successful.' }, status: :ok
      rescue PhoneVerification::VerificationError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Wrong format.' }, status: :unprocessable_entity
    end
  end
  private
  def authenticate_user!
    # Add your authentication logic here.
    # If the user is not authenticated, return a 401 status code.
  end
  def authorize_user!
    # Add your authorization logic here.
    # If the user does not have permission, return a 403 status code.
  end
end
