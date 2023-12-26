class Api::SendOtpCodesController < Api::BaseController
  def create
    @phone_number = ::Auths::PhoneNumber.new({ phone_number: params.dig(:phone_number) })
    unless @phone_number.valid?
      @success = false
      @message = @phone_number.errors.full_messages
      return
    end
    user = User.find_by(phone_number: @phone_number.formatted_phone_number)
    unless user
      @success = false
      @message = "Phone number is not registered"
      return
    end
    service = ::Auths::PhoneVerification.new(@phone_number.formatted_phone_number)
    if service.send_otp
      otp_code = OtpCode.create(user_id: user.id, otp_code: service.otp_code, created_at: Time.now, is_verified: false)
      if otp_code.persisted?
        twilio_gateway = ::TwilioGateway.new
        if twilio_gateway.send_otp(@phone_number.formatted_phone_number, service.otp_code)
          @success = true
          @message = I18n.t('phone_login.otp.send_otp_success')
        else
          @success = false
          @message = "Failed to send OTP"
        end
      else
        @success = false
        @message = "Failed to store OTP"
      end
    else
      @success = false
      @message = I18n.t('common.otp.exceed_amount_sent_otp')
    end
  end
end
