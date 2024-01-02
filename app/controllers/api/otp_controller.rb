class Api::OtpController < Api::BaseController
  # POST /api/otp/request
  def request_otp
    phone_number = params[:phone_number]
    # Validate phone number format
    unless phone_number_valid?(phone_number)
      return render json: { error: 'Invalid phone number format.' }, status: :bad_request
    end

    # Check if phone number is associated with a user
    user = User.find_by(phone_number: phone_number)
    unless user
      return render json: { error: 'Phone number not found.' }, status: :not_found
    end

    # Request a new OTP
    result = OtpService.new.request_new_otp(user.id)
    if result.success?
      render json: { status: 200, message: 'OTP has been sent to your phone.' }, status: :ok
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

  def phone_number_valid?(phone_number)
    phone_number =~ /\A\d{10}\z/
  end
end
