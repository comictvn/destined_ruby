
# frozen_string_literal: true

module UserService
  class LoginOtp < BaseService
    extend Dry::Initializer
    include Dry::Monads[:result]

    param :phone_number
    option :user_id, optional: true

    def call
      raise Exceptions::BadRequest unless verify_phone_number_service.valid?

      user = User.find_or_initialize_by(phone_number: verify_phone_number_service.formatted_phone_number)
      user.save!

      if user_id
        user = User.find_by(id: user_id)
        return Failure(:user_not_found) unless user

        invalidate_existing_otps(user)
        otp_code = generate_unique_otp
        otp_request = create_otp_request(user, otp_code)
        send_otp_to_user(user, otp_code)
        log_otp_transaction(otp_request)

        return Success(otp_request_id: otp_request.id, message: 'New OTP sent successfully.')
      end

      service = ::Auths::PhoneVerification.new(verify_phone_number_service.formatted_phone_number)
      service.send_otp
      Success()
    end

    private

    def invalidate_existing_otps(user)
      user.otp_requests.where('expires_at > ?', Time.current).update_all(expires_at: Time.current)
    end

    def generate_unique_otp
      loop do
        otp_code = SecureRandom.random_number(100000..999999).to_s
        break otp_code unless OtpRequest.exists?(otp_code: otp_code)
      end
    end

    def create_otp_request(user, otp_code)
      user.otp_requests.create!(
        otp_code: otp_code,
        expires_at: Time.current + 5.minutes
      )
    end

    def send_otp_to_user(user, otp_code)
      # Assuming there is a method to send OTP to the user
      # This method should be implemented to actually send the OTP
    end

    def log_otp_transaction(otp_request)
      # Assuming there is a method to log the OTP transaction
      # This method should be implemented to actually log the transaction
    end

    def verify_phone_number_service
      @verify_phone_number_service ||= ::Auths::PhoneNumber.new({ phone_number: phone_number })
    end
  end
end
