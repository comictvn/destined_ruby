class Api::SendOtpCodesController < Api::BaseController
  before_action :validate_phone_number, only: [:create, :send_otp_code]

  def create
    unless @phone_number.valid?
      render json: { success: false, message: "Invalid phone number format." }, status: :bad_request and return
    end

    begin
      phone_verification_service = ::Auths::PhoneVerification.new(@phone_number.formatted_phone_number)
      validation_result = phone_verification_service.validate_phone_number
      unless validation_result[:success]
        render json: { success: false, message: I18n.t(validation_result[:message]) }, status: :bad_request and return
      end
    rescue => e
      render json: { success: false, message: e.message }, status: :internal_server_error and return
    end

    send_otp_codes
    render json: { success: @success, message: @message }, status: @success ? :ok : :unprocessable_entity
  end

  # The send_otp_code method is not needed as per the requirement. The create method already handles sending OTP.
  # Therefore, the send_otp_code method from the NEW CODE is not included in the merged code.

  private

  def send_otp_codes
    service = ::Auths::PhoneVerification.new(@phone_number.formatted_phone_number)

    if service.send_otp
      @success = true
      @message = 'OTP code sent successfully.'
    else
      @success = false
      @message = I18n.t('common.otp.exceed_amount_sent_otp')
    end
  rescue StandardError => e
    @success = false
    @message = e.message
  end

  def validate_phone_number
    @phone_number = ::Auths::PhoneNumber.new({ phone_number: params.dig(:phone_number) })
    unless @phone_number.valid?
      render json: { success: false, message: "Invalid phone number format." }, status: :bad_request and return
    end
  end
end
