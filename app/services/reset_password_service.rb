class ResetPasswordService
  class InvalidOtp < StandardError; end
  class InvalidId < StandardError; end
  def verify_reset_password_request(id, otp)
    reset_password_request = ResetPasswordRequest.find_by(id: id)
    raise InvalidId.new("Invalid id") unless reset_password_request
    if reset_password_request.otp == otp
      reset_password_request.update(status: "verified")
      return true
    else
      raise InvalidOtp.new("Invalid OTP")
    end
  end
end
