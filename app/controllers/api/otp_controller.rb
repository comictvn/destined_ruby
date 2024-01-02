module Api
  class OtpController < Api::BaseController
    before_action :authenticate_user!

    def create
      phone_number = params[:phone_number]

      # Validate phone number format
      unless PhoneNumberValidator.new(phone_number: phone_number).valid?
        return render json: { error: 'Invalid phone number format.' }, status: :unprocessable_entity
      end

      # Check if phone number is associated with any user
      user = User.find_by(phone_number: phone_number)
      unless user
        return render json: { error: 'Phone number not found.' }, status: :bad_request
      end

      # Generate and send OTP
      otp_service = OtpService.new
      result = otp_service.generate_otp_for_user(user.id)

      if result[:error].present?
        render json: { error: result[:error] }, status: :internal_server_error
      else
        render json: { status: 200, message: 'OTP has been sent to your phone.' }, status: :ok
      end
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    def verify
      otp_code = params.require(:otp_code)
      user_id = current_user.id
      otp_verifier = OtpVerifier.new
      verification_result = otp_verifier.verify_otp(otp_code, user_id)

      if verification_result[:verified]
        render json: { status: 200, message: "OTP verified successfully." }, status: :ok
      else
        case verification_result[:message]
        when 'OTP is incorrect or expired.'
          render json: { error: "Invalid OTP. Please try again." }, status: :bad_request
        when 'OTP has expired.'
          render json: { error: "OTP has expired. Please request a new one." }, status: :bad_request
        else
          render json: { error: verification_result[:message] }, status: :internal_server_error
        end
      end
    rescue StandardError => e
      render json: { error: "Verification failed: #{e.message}" }, status: :internal_server_error
    end

    def new
      phone_number = params[:phone_number]

      # Validate phone number format
      unless PhoneNumberValidator.new(phone_number: phone_number).valid?
        return render json: { error: 'Invalid phone number format.' }, status: :unprocessable_entity
      end

      # Check if phone number is associated with any user
      user = User.find_by(phone_number: phone_number)
      unless user
        return render json: { error: 'Phone number not found.' }, status: :bad_request
      end

      # Generate and send OTP
      otp_service = OtpService.new
      result = otp_service.generate_otp_for_user(user.id)

      if result[:error].present?
        render json: { error: result[:error] }, status: :internal_server_error
      else
        render json: { status: 200, message: 'A new OTP has been sent to your phone.' }, status: :ok
      end
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
end
