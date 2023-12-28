# FILE PATH: /app/controllers/api/otp_controller.rb
class Api::OtpController < Api::BaseController
  # POST /api/otp/request
  def create
    phone_number = params.dig(:phone_number)
    phone_number_validator = ::Auths::PhoneNumber.new(phone_number: phone_number)

    unless phone_number_validator.valid?
      return render json: { error: "Invalid phone number format." }, status: :bad_request
    end

    user = User.find_by(phone_number: phone_number_validator.formatted_phone_number)
    if user.nil?
      return render json: { error: "Phone number not found." }, status: :not_found
    end

    phone_verification_service = ::Auths::PhoneVerification.new(phone_number_validator.formatted_phone_number)
    if phone_verification_service.send_otp
      render json: { status: 200, message: "OTP has been sent to your phone." }, status: :ok
    else
      render json: { error: "Failed to send OTP." }, status: :internal_server_error
    end
  end
end
