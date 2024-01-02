module Api
  class OtpController < Api::BaseController
    before_action :authenticate_user!

    def create
      phone_number = params[:phone_number]
      unless PhoneNumberValidator.new(phone_number).valid?
        return render json: { error: 'Invalid phone number format.' }, status: :unprocessable_entity
      end

      user = User.find_by(phone_number: phone_number)
      unless user
        return render json: { error: 'Phone number not found.' }, status: :bad_request
      end

      begin
        otp_service = OtpService.new
        result = otp_service.generate_otp_for_user(user.id)
        render json: { status: result[:status], message: result[:message] }, status: :ok
      rescue => e
        render json: { error: e.message }, status: :internal_server_error
      end
    end

    # The new code is added here to handle the new OTP request
    def new
      phone_number = params[:phone_number]
      unless PhoneNumberValidator.new(phone_number).valid?
        return render json: { error: 'Invalid phone number format.' }, status: :unprocessable_entity
      end

      user = User.find_by(phone_number: phone_number)
      unless user
        return render json: { error: 'Phone number not found.' }, status: :bad_request
      end

      begin
        otp_service = OtpService.new
        result = otp_service.generate_otp_for_user(user.id)
        render json: { status: 200, message: 'A new OTP has been sent to your phone.' }, status: :ok
      rescue => e
        render json: { error: e.message }, status: :internal_server_error
      end
    end
  end
end
