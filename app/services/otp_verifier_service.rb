module Services
  class OtpVerifierService
    class OtpExpired < StandardError; end
    class OtpMismatch < StandardError; end

    def initialize(otp_request_id, otp_code)
      @otp_request_id = otp_request_id
      @otp_code = otp_code
    end

    def verify_otp
      otp_request = OtpRequest.find_by(id: @otp_request_id)
      return { verified: false, message: 'OTP request not found' } if otp_request.nil?

      if Time.current > otp_request.expires_at
        otp_request.update(verified: false)
        return { verified: false, message: 'OTP has expired' }
      end

      if otp_request.otp_code == @otp_code
        otp_request.update(verified: true)
        { verified: true, message: 'OTP verified successfully' }
      else
        { verified: false, message: 'OTP does not match' }
      end
    rescue => e
      { verified: false, message: e.message }
    end

    private

    attr_reader :otp_request_id, :otp_code
  end
end
