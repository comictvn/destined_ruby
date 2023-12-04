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
  def resend
    user = User.find_by(id: params[:user_id])
    return render json: { error: 'User not found or already verified' }, status: :not_found unless user && !user.is_verified
    service = ::Auths::PhoneVerification.new(user.phone_number)
    new_otp_code = service.generate_otp_code
    user.otp_codes.update(otp_code: new_otp_code, created_at: Time.now)
    SendOtpCodeJob.perform_later(user.phone_number, new_otp_code)
    render json: { otp_code: new_otp_code, user_id: user.id, is_verified: user.is_verified }, status: :ok
  end
end
