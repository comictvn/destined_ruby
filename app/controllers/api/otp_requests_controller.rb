# FILE PATH: /app/controllers/api/otp_requests_controller.rb

module Api
  class OtpRequestsController < Api::BaseController
    include PhoneNumberValidator
    include OtpService

    # POST /api/otp/request
    def create
      phone_number = params[:phone_number]
      if valid_phone_number?(phone_number)
        user = User.find_by(phone_number: phone_number)
        if user.nil?
          render json: { error: 'Phone number not found.' }, status: :not_found
        else
          otp_details = send_otp(phone_number)
          render json: { message: 'OTP has been sent to your phone.', otp_details: otp_details }, status: :ok
        end
      else
        render json: { error: 'Invalid phone number format.' }, status: :bad_request
      end
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
end
