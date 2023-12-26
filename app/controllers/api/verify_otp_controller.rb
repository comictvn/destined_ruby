class Api::VerifyOtpController < Api::BaseController
  def verify
    otp_code = params[:otp_code]
    phone_verification = ::Auths::PhoneVerification.new
    if phone_verification.verify_otp(otp_code)
      phone_verification.mark_as_verified
      User.verify_user(phone_verification.user_id)
      render json: { message: 'Phone number has been verified.' }, status: :ok
    else
      render json: { error: 'OTP code does not match.' }, status: :unprocessable_entity
    end
  rescue Twilio::REST::RestError
    render json: { error: 'OTP code has expired.' }, status: :unprocessable_entity
  rescue ::Auths::PhoneVerification::VerifyDeclined
    render json: { error: 'OTP verification declined.' }, status: :unprocessable_entity
  end
end
