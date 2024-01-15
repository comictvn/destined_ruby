class Api::SendOtpCodesController < Api::BaseController
  def create
    @phone_number = ::Auths::PhoneNumber.new({ phone_number: params.dig(:phone_number) })

    unless @phone_number.valid?
      @success = false
      @message = @phone_number.errors.full_messages

      return
    end

    begin
      phone_verification_service = ::Auths::PhoneVerification.new(@phone_number.formatted_phone_number)
      validation_result = phone_verification_service.validate_phone_number
      unless validation_result[:success]
        @success = false
        @message = I18n.t(validation_result[:message])
        return
      end
    rescue => e
      @success = false
      @message = e.message
      return
    end

    service = ::Auths::PhoneVerification.new(@phone_number.formatted_phone_number)

    if service.send_otp
      @success = true
      @message = I18n.t('phone_login.otp.send_otp_success')
    else
      @success = false
      @message = I18n.t('common.otp.exceed_amount_sent_otp')
    end
  end
end
