class OtpRequestService
  # Add new method check_otp_expiry
  def check_otp_expiry(otp_request_id)
    ActiveRecord::Base.transaction do
      otp_request = OtpRequest.find_by(id: otp_request_id)
      raise ActiveRecord::RecordNotFound, "OTP request with id #{otp_request_id} not found." unless otp_request

      is_expired = otp_request.expires_at < Time.current
      if is_expired
        otp_request.update!(status: 'expired') # Assuming 'expired' is a valid status value
      end

      { otp_request_id: otp_request_id, is_expired: is_expired, status: otp_request.status }
    end
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "OtpRequestService#check_otp_expiry: #{e.message}"
    { error: e.message }
  rescue => e
    Rails.logger.error "OtpRequestService#check_otp_expiry: #{e.message}"
    raise
  end
end
