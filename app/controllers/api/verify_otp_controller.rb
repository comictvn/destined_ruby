# FILE PATH: /app/controllers/api/verify_otp_controller.rb
class Api::VerifyOtpController < Api::BaseController
  # Removed duplicate create method and merged the new logic into the existing one
  def create
    phone_number = ::Auths::PhoneNumber.new({ phone_number: params.dig(:phone_number),
                                              otp_code: params.dig(:otp_code) })
    user = User.find_by(phone_number: phone_number.phone_number)
    unless user
      return render json: { error: 'Phone number not found' }, status: :not_found
    end

    if phone_number.valid?
      verification_result = ::Auths::PhoneVerification.new(phone_number.formatted_phone_number).verify_otp(phone_number.otp_code)

      case verification_result
      when :verified
        render json: { message: 'OTP successfully verified' }, status: :ok
      when :invalid
        render json: { error: 'Invalid OTP. Please try again.' }, status: :unprocessable_entity
      when :expired
        render json: { error: 'OTP has expired. Please request a new one.' }, status: :unprocessable_entity
      else
        render json: { error: 'Internal server error' }, status: :internal_server_error
      end
    else
      render json: { error: 'Invalid parameters' }, status: :bad_request
    end
  rescue Twilio::REST::RestError
    render json: { error: 'OTP has expired. Please request a new one.' }, status: :unprocessable_entity
  rescue ::Auths::PhoneVerification::VerifyDeclined
    render json: { error: 'Invalid OTP. Please try again.' }, status: :unprocessable_entity
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  # Existing verify method remains unchanged
  def verify
    otp_request_id = params[:otp_request_id]
    otp_code = params[:otp_code]

    otp_request = OtpRequest.find_by(id: otp_request_id)
    if otp_request.nil?
      render json: { error: 'OTP request not found' }, status: :not_found
      return
    end

    if Time.current > otp_request.expires_at
      otp_request.update(status: 'expired')
      render json: { error: 'OTP has expired' }, status: :unprocessable_entity
    elsif otp_request.otp_code == otp_code
      otp_request.update(verified: true, status: 'verified')
      render json: { otp_request_id: otp_request.id, verified: otp_request.verified, status: otp_request.status }, status: :ok
    else
      render json: { error: 'Incorrect OTP' }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotSaved => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
