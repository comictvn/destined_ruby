require 'securerandom'

class OtpService
  OTP_EXPIRY_DURATION = 5.minutes

  def generate_otp(user_id)
    user = User.find_by(id: user_id)
    raise StandardError, 'User not found' unless user

    otp_code = SecureRandom.hex(3)
    otp_request = OtpRequest.create!(
      user_id: user_id,
      otp_code: otp_code,
      created_at: Time.current,
      expires_at: Time.current + OTP_EXPIRY_DURATION,
      verified: false
    )

    if Rails.env.development? || user.phone_number == '00000000000'
      Rails.logger.info "Sent OTP code to #{user.phone_number}"
    else
      SendOtpCodeJob.perform_later(user.phone_number, otp_code)
    end

    { otp_request_id: otp_request.id, message: 'OTP has been sent successfully.' }
  rescue => e
    { error: e.message }
  end
end


