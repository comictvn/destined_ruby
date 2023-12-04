module Auths
  class PhoneVerification < BaseService
    class VerifyDeclined < StandardError; end
    class InvalidPhoneNumber < StandardError; end
    class InvalidOtpCode < StandardError; end
    class OtpCodeExpired < StandardError; end
    SEND_OTP_LIMIT = 5
    def initialize(user_id_or_phone_number)
      super()
      if user_id_or_phone_number.is_a?(Integer)
        @user = User.find(user_id_or_phone_number)
        raise ActiveRecord::RecordNotFound, "User not found" unless @user
        @phone_number = @user.phone_number
      else
        @phone_number = user_id_or_phone_number
      end
    end
    def verify_phone_number(phone_number)
      raise InvalidPhoneNumber unless Phonelib.valid?(phone_number)
      user = User.find_by(phone_number: phone_number)
      raise Exceptions::PhoneNumberAlreadyRegistered if user
      otp_code = generate_otp_code(user.id)
      TwilioGateway.new.send_otp(phone_number, otp_code)
      UserService::Update.new(user).call(is_verified: false)
      { message: 'OTP code has been sent successfully.' }
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
    def resend_otp
      return false unless @user.is_verified == false
      otp_code = generate_otp
      OtpCode.where(user_id: @user.id).update_all(otp_code: otp_code, created_at: Time.current)
      send_otp(otp_code)
      { otp_code: otp_code, user_id: @user.id, is_verified: @user.is_verified }
    end
    def verify_otp(phone_number, otp_code)
      raise InvalidPhoneNumber unless Phonelib.valid?(phone_number)
      user = User.find_by(phone_number: phone_number)
      raise InvalidOtpCode unless user
      otp = OtpCode.find_by(user_id: user.id, otp_code: otp_code)
      raise OtpCodeExpired unless otp && otp.created_at > 10.minutes.ago
      otp.update(is_verified: true)
      { status: 200, message: 'OTP code has been verified.' }
    end
    def generate_otp_code(user_id)
      otp_code = SecureRandom.hex(3)
      OtpCode.create(user_id: user_id, otp_code: otp_code, is_verified: false, created_at: Time.current)
      otp_code
    end
    private
    attr_reader :phone_number, :user
    def twilio
      ::TwilioGateway.new.verification_service
    end
    def whitelisted?
      whitelisted_regex = ENV['whitelisted_phone_regex'] || '00000000000'
      phone_number.match(/^#{Regexp.quote(whitelisted_regex)}/)
    end
    def generate_otp
      rand.to_s[2..7]
    end
  end
end
