class Api::SendOtpCodesController < Api::BaseController
  before_action :validate_phone_number, only: :create

  def create
    unless @phone_number.valid?
      @success = false
      @message = @phone_number.errors.full_messages
      render json: { success: @success, message: @message }, status: :bad_request and return
    end

    begin
      phone_verification_service = ::Auths::PhoneVerification.new(@phone_number.formatted_phone_number)
      validation_result = phone_verification_service.validate_phone_number
      unless validation_result[:success]
        @success = false
        @message = I18n.t(validation_result[:message])
        render json: { success: @success, message: @message }, status: :bad_request and return
      end
    rescue => e
      @success = false
      @message = e.message
      render json: { success: @success, message: @message }, status: :internal_server_error and return
    end

    send_otp_codes
    render json: { success: @success, message: @message }, status: @success ? :ok : :unprocessable_entity
  end

  private

  def send_otp_codes
    service = ::Auths::PhoneVerification.new(@phone_number.formatted_phone_number)

    if service.send_otp
      @success = true
      @message = I18n.t('phone_login.otp.send_otp_success')
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
      render json: { success: false, message: @phone_number.errors.full_messages }, status: :bad_request and return
    end
  end
end
