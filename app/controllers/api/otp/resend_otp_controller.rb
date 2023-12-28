# FILE PATH: /app/controllers/api/otp/resend_otp_controller.rb
class Api::Otp::ResendOtpController < Api::BaseController
  def create
    phone_number_service = ::Auths::PhoneNumber.new(phone_number: params[:phone_number])

    if phone_number_service.valid?
      user = User.find_by(phone_number: phone_number_service.formatted_phone_number)

      if user
        # Enqueue job to send OTP
        SendOtpCodeJob.perform_later(user.id)
        render json: { status: 200, message: 'A new OTP has been sent to your phone.' }, status: :ok
      else
        render json: { error: 'Phone number not found.' }, status: :not_found
      end
    else
      render json: { error: 'Invalid phone number format.' }, status: :bad_request
    end
  end
end
