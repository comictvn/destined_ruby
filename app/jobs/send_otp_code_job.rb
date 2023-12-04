class SendOtpCodeJob < ApplicationJob
  queue_as :critical
  sidekiq_options retry: 1
  def perform(user_id, otp_code = nil, resend = false)
    user = User.find_by(id: user_id)
    return unless user
    otp_code = if resend
                 otp = OtpCode.where(user_id: user.id, is_verified: false).last
                 otp.update(otp_code: SecureRandom.hex(3), created_at: Time.now)
                 otp.otp_code
               else
                 otp_code || SecureRandom.hex(3)
               end
    twilio.verifications.create(to: user.phone_number, channel: 'sms', code: otp_code)
  end
  private
  def twilio
    TwilioGateway.new.verification_service
  end
end
