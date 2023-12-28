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

  # POST /api/otp/resend
  def resend
    phone_number = params[:phone_number]
    user = User.find_by(phone_number: phone_number)

    if user.nil?
      render json: { error: "Phone number not found." }, status: :not_found
    elsif invalid_phone_number_format?(phone_number)
      render json: { error: "Invalid phone number format." }, status: :bad_request
    else
      # Assuming OtpService exists and has a resend_otp method
      otp_service = OtpService.new(user.id)
      if otp_service.resend_otp
        render json: { message: "A new OTP has been sent to your phone." }, status: :ok
      else
        render json: { error: "Failed to send OTP." }, status: :internal_server_error
      end
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def invalid_phone_number_format?(phone_number)
    phone_number !~ /\A\+?\d{10,15}\z/
  end
end
