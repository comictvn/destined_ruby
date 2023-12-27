# frozen_string_literal: true

module UserService
  class LoginOtp < BaseService
    extend Dry::Initializer
    include Dry::Monads[:result]

    param :phone_number

    def call
      verify_phone_number_result = verify_phone_number_service.call
      return Failure(:invalid_phone_number) unless verify_phone_number_result.success?

      normalized_phone_number = verify_phone_number_service.formatted_phone_number

      return Failure(:otp_limit_reached) if check_otp_sending_limit(normalized_phone_number)

      user = User.find_or_initialize_by(phone_number: normalized_phone_number)
      begin
        user.save!
      rescue ActiveRecord::RecordInvalid => e
        return Failure(:user_save_failed)
      end

      send_otp(normalized_phone_number)

      increment_sending_count(normalized_phone_number)
      Success()
    end

    private

    def check_otp_sending_limit(phone_number)
      limit = Rails.cache.fetch(otp_limit_cache_key(phone_number), expires_in: 1.day) { 0 }
      limit >= 5
    end

    def increment_sending_count(phone_number)
      Rails.cache.increment(otp_limit_cache_key(phone_number))
    end

    def otp_limit_cache_key(phone_number)
      "otp_send_limit:#{phone_number}:#{Date.today.iso8601}"
    end

    def whitelisted_number?(phone_number)
      whitelisted_numbers = ['+1234567890', '+0987654321']
      whitelisted_numbers.include?(phone_number)
    end

    def verify_phone_number_service
      @verify_phone_number_service ||= ::Auths::PhoneNumber.new({ phone_number: phone_number })
    end

    def send_otp(phone_number)
      service = ::Auths::PhoneVerification.new(phone_number)
      otp_code = service.generate_otp_code

      if Rails.env.development? || whitelisted_number?(phone_number)
        Rails.logger.info "OTP Code: #{otp_code}"
      else
        SendOtpCodeJob.perform_later(phone_number, otp_code)
      end
    end
  end
end
