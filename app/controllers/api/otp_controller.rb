# If the file does not exist, create a new file in the specified path.
# Inherit from `Api::BaseController` to ensure consistency with other API controllers.

class Api::OtpController < Api::BaseController
  # GET /api/otp/check-expiry
  def check_expiry
    otp_code = params[:otp_code]
    phone_number = params[:phone_number]

    return render json: { error: 'OTP code is missing.' }, status: :bad_request if otp_code.blank?
    return render json: { error: 'Phone number is missing.' }, status: :bad_request if phone_number.blank?

    user = User.find_by(phone_number: phone_number)
    return render json: { error: 'Phone number not found.' }, status: :not_found if user.nil?

    otp_request = user.otp_requests.find_by(otp_code: otp_code)
    if otp_request.nil?
      render json: { error: 'OTP does not exist.' }, status: :not_found
    elsif Time.current > otp_request.expires_at
      otp_request.update(status: 'expired')
      render json: { status: 200, otp_status: 'expired' }, status: :ok
    else
      render json: { status: 200, otp_status: 'active' }, status: :ok
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end
end
