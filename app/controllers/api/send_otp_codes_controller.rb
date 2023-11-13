class Api::SendOtpCodesController < Api::BaseController
  def create
    @phone_number = ::Auths::PhoneNumber.new({ phone_number: params.dig(:phone_number) })

    unless @phone_number.valid?
      @success = false
      @message = @phone_number.errors.full_messages

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
