class Api::OtpController < Api::BaseController
  include ApiErrorResponder

  rescue_from PhoneNumberValidator::InvalidFormatError, with: :handle_invalid_phone_format
  rescue_from ActiveRecord::RecordNotFound, with: :handle_phone_number_not_found

  # POST /api/otp/request-new
  def request_new_otp
    phone_number = params[:phone_number]
    validate_phone_number!(phone_number)

    user = find_user_by_phone_number(phone_number)
    result = OtpService.new.request_new_otp(user.id)

    if result.success?
      render json: { status: 200, message: 'A new OTP has been sent to your phone.' }, status: :ok
    else
      render json: { error: result.failure }, status: :internal_server_error
    end
  end

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

  private

  def validate_phone_number!(phone_number)
    PhoneNumberValidator.new(phone_number).validate!
  end

  def find_user_by_phone_number(phone_number)
    User.find_by!(phone_number: phone_number)
  end

  def handle_invalid_phone_format
    render json: { error: 'Invalid phone number format.' }, status: :bad_request
  end

  def handle_phone_number_not_found
    render json: { error: 'Phone number not found.' }, status: :not_found
  end

  # This method is kept from the existing code for backward compatibility
  # It uses a simple regex to validate the phone number format
  def phone_number_valid?(phone_number)
    phone_number =~ /\A\d{10}\z/
  end
end
