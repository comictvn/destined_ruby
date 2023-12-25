# frozen_string_literal: true

module UserService
  class LoginOtp < BaseService
    extend Dry::Initializer
    include Dry::Monads[:result]

    param :phone_number

    def call
      return Failure() if check_otp_sending_limit

      raise Exceptions::BadRequest unless verify_phone_number_service.valid?

      user = User.find_or_initialize_by(phone_number: verify_phone_number_service.formatted_phone_number)
      user.save!

      service = ::Auths::PhoneVerification.new(verify_phone_number_service.formatted_phone_number)
      if Rails.env.development? || whitelisted_number?(verify_phone_number_service.formatted_phone_number)
        Rails.logger.info "OTP Code: #{service.generate_otp_code}" # Assuming generate_otp_code is a method that returns the OTP code
      else
        SendOtpCodeJob.perform_later(verify_phone_number_service.formatted_phone_number)
      end

      increment_sending_count(verify_phone_number_service.formatted_phone_number)
      Success()
    end

    private

    def check_otp_sending_limit
      limit = Rails.cache.fetch(otp_limit_cache_key(phone_number), expires_in: 1.day) { 0 }
      return true if limit >= 5

      false
    end

    def increment_sending_count(phone_number)
      Rails.cache.increment(otp_limit_cache_key(phone_number))
    end

    def otp_limit_cache_key(phone_number)
      "otp_send_limit:#{phone_number}:#{Date.today.iso8601}"
    end

    def whitelisted_number?(phone_number)
      # Define logic to check if the phone number is whitelisted
      # This is a placeholder, the actual implementation will depend on the project's requirements
      whitelisted_numbers = ['+1234567890', '+0987654321'] # Example whitelist
      whitelisted_numbers.include?(phone_number)
    end

    def verify_phone_number_service
      @verify_phone_number_service ||= ::Auths::PhoneNumber.new({ phone_number: phone_number })
    end
  end
end
