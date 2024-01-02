# frozen_string_literal: true

class OtpService
  def generate_otp_for_user(user_id)
    user = User.find(user_id)
    otp_code = SecureRandom.hex(3)
    otp_request = OtpRequest.create!(
      user_id: user.id,
      otp_code: otp_code,
      expires_at: Time.current + 5.minutes,
      verified: false
    )

    SmsSender.send_sms(user.phone_number, otp_code)

    OtpTransaction.create!(
      transaction_id: SecureRandom.uuid,
      otp_request_id: otp_request.id,
      status: 'sent'
    )

    { otp_request_id: otp_request.id, message: 'OTP sent successfully.' }
  rescue ActiveRecord::RecordNotFound
    { error: 'User not found.' }
  end
end
