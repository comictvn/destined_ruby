# frozen_string_literal: true

require 'securerandom'

class OtpService
  include Dry::Monads[:result]
  OTP_EXPIRY_DURATION = 5.minutes

  def request_new_otp(user_id)
    user = User.find_by(id: user_id)
    raise Exceptions::NotFound, 'User not found' unless user

    OtpRequest.where(user_id: user_id).where('expires_at < ?', Time.current).destroy_all

    otp_code = generate_otp_code
    otp_request = OtpRequest.create!(
      user_id: user_id,
      otp_code: otp_code,
      created_at: Time.current,
      expires_at: 15.minutes.from_now
    )

    send_otp_code(user.phone_number, otp_code)

    Success(otp_request_id: otp_request.id, message: 'New OTP sent successfully.')
  rescue => e
    Failure(e.message)
  end

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
      send_otp_code(user.phone_number, otp_code)
    end

    { otp_request_id: otp_request.id, message: 'OTP has been sent successfully.' }
  rescue => e
    { error: e.message }
  end

  private

  def generate_otp_code
    # Using SecureRandom.hex for consistency with the existing code
    SecureRandom.hex(3)
  end

  def send_otp_code(phone_number, otp_code)
    # Assuming TwilioGateway or SendOtpCodeJob exists as per guideline
    SendOtpCodeJob.perform_later(phone_number, otp_code)
    # Alternatively, if using a service like TwilioGateway directly:
    # TwilioGateway.new.send_message(phone_number, "Your OTP code is: #{otp_code}")
  end
end
