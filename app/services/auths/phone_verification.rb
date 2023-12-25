module Auths
  class PhoneVerification < BaseService
    class VerifyDeclined < StandardError; end

    # limit sending otp 5 times per day
    SEND_OTP_LIMIT = 5

    def initialize(phone_number)
      super()

      @phone_number = phone_number
    end

    def send_otp
      cache_key = "phone_number_#{@phone_number}/#{Time.current.strftime('%Y-%m-%d')}"
      current_sending_count = Rails.cache.fetch(cache_key) { 0 }
      
      if current_sending_count >= SEND_OTP_LIMIT
        return { success: false, error: true, message: "OTP send limit reached for today." }
      end

      otp_code = generate_otp_code # Assuming this method exists to generate the OTP code

      begin
        if Rails.env.development? || whitelisted?
          logger.info "Sent OTP code: #{otp_code} to #{@phone_number}"
        else
          ::SendOtpCodeJob.perform_later(@phone_number, otp_code)
        end
        Rails.cache.write(cache_key, current_sending_count + 1, expires_in: (Time.current.end_of_day - Time.current).to_i)
      rescue => e
        logger.error "Failed to send OTP: #{e.message}"
        return { success: false, error: true, message: "Failed to send OTP." }
      end

      { success: true, error: false, message: "OTP sent successfully." }
    end

    def verify_otp(otp_code)
      return true if Rails.env.development? || whitelisted?

      check = twilio.verification_checks.create(to: @phone_number, code: otp_code)
      raise VerifyDeclined unless check.status == 'approved'
    end

    private

    attr_reader :phone_number

    def twilio
      ::TwilioGateway.new.verification_service
    end

    def whitelisted?
      whitelisted_regex = ENV['whitelisted_phone_regex'] || '00000000000'
      @phone_number.match(/^#{Regexp.quote(whitelisted_regex)}/)
    end

    def generate_otp_code
      rand(100000..999999).to_s
    end
  end
end
