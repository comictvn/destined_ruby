class Api::OtpController < Api::BaseController
  # POST /api/otp/verify
  def verify
    otp_code = params[:otp_code]
    otp_request_id = params[:otp_request_id] # Assuming the service needs this parameter

    begin
      result = OtpVerifierService.new.verify_otp(otp_request_id, otp_code)

      if result[:verified]
        render json: { status: 200, message: I18n.t('otp.verification_success') }, status: :ok
      else
        case result[:error]
        when :invalid_otp
          render json: { error: I18n.t('otp.invalid_otp_error') }, status: :bad_request
        when :expired_otp
          render json: { error: I18n.t('otp.expired_otp_error') }, status: :bad_request
        else
          render json: { error: result[:message] }, status: :unprocessable_entity
        end
      end
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
end
