class Api::VerifyOtpController < Api::BaseController
  # POST /api/verify_otp
  def create
    otp_request_id = params[:otp_request_id]
    otp_code = params[:otp_code]

    result = OtpVerifierService.new.verify(otp_request_id, otp_code)

    if result[:verified]
      render json: { verified: true, message: I18n.t('otp.verification_success') }, status: :ok
    else
      render json: { verified: false, message: result[:message] }, status: :unprocessable_entity
    end
  end
end

class OtpVerifierService
  def verify(otp_request_id, otp_code)
    otp_request = OtpRequest.find_by(id: otp_request_id)
    return { verified: false, message: I18n.t('otp.request_not_found') } unless otp_request

    if otp_request.expires_at < Time.current
      otp_request.update(verified: false)
      { verified: false, message: I18n.t('otp.expired') }
    elsif otp_request.otp_code == otp_code
      otp_request.update(verified: true)
      { verified: true, message: I18n.t('otp.verified') }
    else
      { verified: false, message: I18n.t('otp.invalid_code') }
    end
  end
end
