class OtpService
  OTP_EXPIRY_TIME = 5.minutes

  def initialize(user_id)
    @user = User.find_by(id: user_id)
    raise ArgumentError, 'User not found' unless @user
  end

  def resend_otp
    invalidate_previous_otps
    otp_code = generate_unique_otp
    otp_request = create_otp_request(otp_code)

    SendOtpCodeJob.perform_later(@user.phone_number, otp_code)

    {
      otp_request_id: otp_request.id,
      otp_code: otp_code,
      created_at: otp_request.created_at,
      expires_at: otp_request.expires_at,
      status: otp_request.status
    }
  end

  private

  def invalidate_previous_otps
    @user.otp_requests.where(status: 'pending').update_all(status: 'invalidated')
  end

  def generate_unique_otp
    SecureRandom.hex(3).upcase
  end

  def create_otp_request(otp_code)
    @user.otp_requests.create!(
      otp_code: otp_code,
      expires_at: Time.current + OTP_EXPIRY_TIME,
      verified: false,
      status: 'pending'
    )
  end
end
