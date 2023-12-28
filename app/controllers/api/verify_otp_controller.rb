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

  def verify
    otp_request_id = params[:otp_request_id]
    otp_code = params[:otp_code]

    otp_request = OtpRequest.find_by(id: otp_request_id)
    if otp_request.nil?
      render json: { error: 'OTP request not found' }, status: :not_found
      return
    end

    if Time.current > otp_request.expires_at
      otp_request.update(status: 'expired') # Updated to use the update method
      render json: { error: 'OTP has expired' }, status: :unprocessable_entity
    elsif otp_request.otp_code == otp_code
      otp_request.update(verified: true, status: 'verified') # Updated to use the update method
      render json: { otp_request_id: otp_request.id, verified: otp_request.verified, status: otp_request.status }, status: :ok
    else
      render json: { error: 'Incorrect OTP' }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotSaved => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
