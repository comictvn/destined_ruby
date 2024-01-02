class OtpVerifier
  def verify_otp(otp_code, user_id)
    response = { verified: false, message: '' }
    ActiveRecord::Base.transaction do
      otp_request = OtpRequest.find_by(user_id: user_id)
      if otp_request && otp_request.otp_code == otp_code && otp_request.expires_at > Time.current
        otp_request.update!(verified: true)
        OtpTransaction.create_or_find_by(otp_request_id: otp_request.id) do |transaction|
          transaction.status = 'verified'
        end
        response[:verified] = true
        response[:message] = 'OTP successfully verified.'
      else
        OtpTransaction.create_or_find_by(otp_request_id: otp_request&.id) do |transaction|
          transaction.status = 'failed'
        end
        response[:message] = 'OTP is incorrect or expired.'
      end
    end
  rescue => e
    response[:message] = "Verification failed: #{e.message}"
  ensure
    return response
  end
end

# Other methods in OtpVerifier class...

