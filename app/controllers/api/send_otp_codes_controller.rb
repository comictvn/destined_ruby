class Api::SendOtpCodesController < Api::BaseController
  before_action :authenticate_user!
  def create
    @phone_number = ::Auths::PhoneNumber.new({ phone_number: params.dig(:phone_number) })
    unless @phone_number.valid?
      return render json: { error: 'Invalid phone number.' }, status: :unprocessable_entity
    end
    service = ::Auths::PhoneVerification.new(@phone_number.formatted_phone_number)
    if service.send_otp
      render json: { status: 200, message: 'OTP sent successfully.' }, status: :ok
    else
      render json: { error: I18n.t('common.otp.exceed_amount_sent_otp') }, status: :bad_request
    end
  end
  def resend
    user = User.find_by(phone: params[:phone])
    if user.nil? || user.is_verified
      return render json: { error: 'User not found or already verified' }, status: :not_found
    end
    service = ::Auths::PhoneVerification.new(user.phone)
    new_otp_code = service.generate_otp_code
    user.otp_codes.create(otp_code: new_otp_code, is_verified: false)
    SendOtpCodeJob.perform_later(user.phone, new_otp_code)
    render json: { otp_code: new_otp_code, user_id: user.id, is_verified: user.is_verified }, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :bad_request
  end
end
