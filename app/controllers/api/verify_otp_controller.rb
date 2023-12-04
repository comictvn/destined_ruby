class Api::VerifyOtpController < Api::BaseController
  before_action :authenticate_user!
  before_action :authorize_user!
  before_action :validate_params
  def verify_otp
    phone_number = params[:phone_number]
    otp_code = params[:otp_code]
    user_id = current_user.id
    begin
      otp = PhoneVerification.verify_otp(phone_number, otp_code, user_id)
      if otp
        UserService::Update.new(user: current_user, params: { is_verified: true }).call
        otp.update(is_verified: true)
        render_success(message: 'Phone number verified successfully.')
      else
        render json: { error: 'Invalid or expired OTP code.' }, status: :unprocessable_entity
      end
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
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
  def validate_params
    phone_number = params[:phone_number]
    otp_code = params[:otp_code]
    if phone_number.blank? || !phone_number.match(/\A\+?[1-9]\d{1,14}\z/)
      render json: { error: 'Invalid phone number.' }, status: :bad_request
    elsif otp_code.blank? || otp_code.length != 6
      render json: { error: 'Invalid OTP code.' }, status: :bad_request
    end
  end
end
