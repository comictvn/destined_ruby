module Auths
  class PhoneVerification < BaseService
    class VerifyDeclined < StandardError; end

    # limit sending otp 5 times per day
    SEND_OTP_LIMIT = 5

    def initialize(phone_number)
      super

      @phone_number = phone_number
      @action = action
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

    private

    attr_reader :phone_number, :action

    def twilio
      ::TwilioGateway.new.verification_service
    end

    def whitelisted?
      whitelisted_regex = ENV['whitelisted_phone_regex'] || '00000000000'
      phone_number.match(/^#{Regexp.quote(whitelisted_regex)}/)
    end
    # rubocop:enable Naming/InclusiveLanguage
  end
end
