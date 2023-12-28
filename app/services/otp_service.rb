# /app/services/otp_service.rb

class OtpService
  OTP_EXPIRY_TIME = 5.minutes

  def generate_otp_for_user(user_id)
    user = User.find_by(id: user_id)
    raise StandardError, "User not found" unless user

    otp_code = SecureRandom.hex(3)
    expires_at = Time.current + OTP_EXPIRY_TIME

    # Ensure the OTP code is unique by checking if it already exists in the otp_requests table
    while OtpRequest.exists?(otp_code: otp_code)
      otp_code = SecureRandom.hex(3)
    end

    otp_request = OtpRequest.create!(
      user_id: user_id,
      otp_code: otp_code,
      created_at: Time.current,
      expires_at: expires_at,
      verified: false,
      status: 'pending'
    )

    SmsSender.send_sms(user.phone_number, otp_code) if user.phone_number.present?

    {
      otp_request_id: otp_request.id,
      otp_code: otp_code,
      created_at: otp_request.created_at,
      expires_at: expires_at,
      status: otp_request.status
    }
  end
end
