class Api::VerifyOtpController < Api::BaseController
  # POST /api/verify_otp
  def create
    phone_number = params[:phone_number]
    otp_code = params[:code]

    # Validate phone number and OTP code format
    unless phone_number.present? && phone_number.match?(/\A\+?\d+\z/)
      return head :bad_request, message: I18n.t('otp.invalid_phone_number_format')
    end
    unless otp_code.present? && otp_code.match?(/\A\d{6}\z/)
      return head :bad_request, message: I18n.t('otp.invalid_otp_code_format')
    end

    # Verify OTP using the User model's verify_otp? method
    user = User.verify_otp?(phone_number, otp_code)
    if user
      render json: { status: 200, message: I18n.t('otp.code_verified_successfully') }, status: :ok
    else
      head :unprocessable_entity, message: I18n.t('otp.verification_failed')
    end
  rescue StandardError => e
    head :internal_server_error, message: e.message
  end
end
