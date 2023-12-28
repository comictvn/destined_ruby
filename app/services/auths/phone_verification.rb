module Auths
  class PhoneVerification < BaseService
    class VerifyDeclined < StandardError; end
    class UserNotFound < StandardError; end

    # limit sending otp 5 times per day
    SEND_OTP_LIMIT = 5

    def initialize(phone_number)
      super()

      @phone_number = phone_number
    end

    def send_otp
      cache_key = "phone_number_#{phone_number}/#{Time.current.strftime('%Y-%m-%d')}"
      current_sending_count = Rails.cache.fetch(cache_key,
                                                expires_in: (Time.current.end_of_day - Time.current).to_i).to_i
      return false if current_sending_count >= ::Auths::PhoneVerification::SEND_OTP_LIMIT

      if Rails.env.development? || whitelisted?
        logger.info "Sent OTP code to #{phone_number}"
      else
        ::SendOtpCodeJob.perform_later(phone_number)
      end
      Rails.cache.write(cache_key, current_sending_count + 1)

      true
    end

    def verify_otp(otp_code)
      return true if Rails.env.development? || whitelisted?

      check = twilio.verification_checks.create(to: phone_number, code: otp_code)
      raise VerifyDeclined unless check.status == 'approved'
    end

    def resend_otp(user_id)
      user = User.find_by(id: user_id)
      raise UserNotFound, "User with id #{user_id} not found" unless user

      ActiveRecord::Base.transaction do
        OtpRequest.invalidate_previous_otps(user_id)

        otp_code = SecureRandom.hex(3).upcase
        expires_at = 10.minutes.from_now

        otp_request = OtpRequest.create!(
          user_id: user_id,
          otp_code: otp_code,
          created_at: Time.current,
          expires_at: expires_at,
          verified: false,
          status: 'active'
        )

        ::SendOtpCodeJob.perform_later(user.phone_number, otp_code)

        {
          otp_request_id: otp_request.id,
          otp_code: otp_request.otp_code,
          created_at: otp_request.created_at,
          expires_at: otp_request.expires_at,
          status: otp_request.status
        }
      end
    rescue ActiveRecord::RecordInvalid => e
      raise StandardError, e.message
    end

    private

    attr_reader :phone_number

    def twilio
      ::TwilioGateway.new.verification_service
    end

    def whitelisted?
      whitelisted_regex = ENV['whitelisted_phone_regex'] || '00000000000'
      phone_number.match(/^#{Regexp.quote(whitelisted_regex)}/)
    end
  end
end
