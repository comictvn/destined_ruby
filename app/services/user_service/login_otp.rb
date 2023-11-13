# frozen_string_literal: true

module UserService
  class LoginOtp < BaseService
    extend Dry::Initializer
    include Dry::Monads[:result]

    param :phone_number

    def call
      raise Exceptions::BadRequest unless verify_phone_number_service.valid?

      user = User.find_or_initialize_by(phone_number: verify_phone_number_service.formatted_phone_number)
      user.save!

      service = ::Auths::PhoneVerification.new(verify_phone_number_service.formatted_phone_number)
      service.send_otp
      Success()
    end

    private

    def verify_phone_number_service
      @verify_phone_number_service ||= ::Auths::PhoneNumber.new({ phone_number: phone_number })
    end
  end
end
