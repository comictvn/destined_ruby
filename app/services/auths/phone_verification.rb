module Auths
  class PhoneVerification < BaseService
    require 'phonelib'
    class VerifyDeclined < StandardError; end

    # limit sending otp 5 times per day
    SEND_OTP_LIMIT = 5

    def initialize(phone_number)
      super()

      @phone_number = phone_number
    end

    def send_otp(phone_number: nil)
      phone_number ||= @phone_number
      cache_key = "phone_number_#{phone_number}/#{Time.current.strftime('%Y-%m-%d')}"
      current_sending_count = Rails.cache.fetch(cache_key,
                                                expires_in: (Time.current.end_of_day - Time.current).to_i).to_i
      return { success: false, message: 'OTP limit reached for today.' } if current_sending_count >= SEND_OTP_LIMIT

      otp_code = SecureRandom.hex(3) # Generates a random hex string of length 6
      expiration_time = 5.minutes.from_now

      begin
        OtpRequest.create_otp_request(
          user_id: user.id,
          phone_number: phone_number,
          otp_code: otp_code,
          expiration_time: expiration_time
        )

        if Rails.env.development? || whitelisted?
          logger.info "Sent OTP code to #{phone_number}: #{otp_code}"
        else
          TwilioGateway.new.send_sms(phone_number, "Your OTP code is: #{otp_code}")
        end
        Rails.cache.write(cache_key, current_sending_count + 1)
        { success: true, message: 'OTP has been sent.' }
      rescue => e
        { success: false, message: e.message }
      end
    end

    def validate_phone_number(phone_number)
      validation = Phonelib.valid?(phone_number)
      user_exists = User.find_by(phone_number: phone_number).present?

      if validation && !user_exists
        { success: true, message: 'Phone number is valid and not registered.' }
      elsif !validation
        { success: false, message: 'Invalid phone number format.' }
      elsif user_exists
        { success: false, message: 'Phone number already registered.' }
      end
    end

    def verify_otp(otp_code)
      return true if Rails.env.development? || whitelisted?

      check = twilio.verification_checks.create(to: phone_number, code: otp_code)
      raise VerifyDeclined unless check.status == 'approved'
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
