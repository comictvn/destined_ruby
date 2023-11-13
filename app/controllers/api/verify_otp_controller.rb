class Api::VerifyOtpController < Api::BaseController
  def create
    phone_number = ::Auths::PhoneNumber.new({ phone_number: params.dig(:phone_number),
                                              otp_code: params.dig(:otp_code) })
    if phone_number.valid?
      ::Auths::PhoneVerification.new(phone_number.formatted_phone_number).verify_otp(params.dig(:otp_code))
      head :ok, message: I18n.t('common.200')
    else
      head :unauthorized
    end
  rescue Twilio::REST::RestError
    head :unprocessable_entity, message: I18n.t('otp.notp_expired')
  rescue ::Auths::PhoneVerification::VerifyDeclined
    head :unprocessable_entity, message: I18n.t('otp.verification_declined')
  end
end
