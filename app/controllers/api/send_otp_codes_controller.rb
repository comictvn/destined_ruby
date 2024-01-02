class Api::SendOtpCodesController < Api::BaseController
  def create
    @phone_number = ::Auths::PhoneNumber.new({ phone_number: params.dig(:phone_number) })

    unless @phone_number.valid?
      @success = false
      @message = @phone_number.errors.full_messages

      return
    end

    service = ::Auths::PhoneVerification.new(@phone_number.formatted_phone_number)

    if service.send_otp
      @success = true
      @message = I18n.t('phone_login.otp.send_otp_success')
    else
      @success = false
      @message = I18n.t('common.otp.exceed_amount_sent_otp')
    end
  end

  def request_new_otp
    user_id = params[:user_id]
    user = User.find_by(id: user_id)

    if user.nil?
      render json: { error: 'User not found' }, status: :not_found
      return
    end

    ActiveRecord::Base.transaction do
      user.invalidate_otps
      otp_code = SecureRandom.hex(3)
      otp_request = user.otp_requests.create!(otp_code: otp_code, expires_at: 5.minutes.from_now)
      SendOtpCodeJob.perform_later(user.phone_number, otp_code)
      otp_transaction = otp_request.create_otp_transaction!(transaction_id: SecureRandom.uuid, status: 'resent')
    end

    render json: { otp_request_id: otp_request.id, message: 'New OTP has been sent.' }, status: :ok
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
end
