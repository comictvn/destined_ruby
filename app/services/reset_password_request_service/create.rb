# typed: true
class ResetPasswordRequestService::Create < BaseService
  def initialize(user_id, otp)
    @user_id = user_id
    @otp = otp
  end
  def execute
    user = User.find_by(id: @user_id)
    if user.nil?
      logger.error("User with id: #{@user_id} does not exist.")
      return nil
    end
    reset_password_request = ResetPasswordRequest.new(user_id: @user_id, otp: @otp, status: 'pending')
    if reset_password_request.save
      return reset_password_request.status
    else
      logger.error("Failed to create reset password request for user_id: #{@user_id}")
      return nil
    end
  end
  def verify_reset_password_request(id, otp)
    reset_password_request = ResetPasswordRequest.find_by(id: id)
    raise "Reset password request not found." if reset_password_request.nil?
    raise "Invalid OTP." if reset_password_request.otp != otp
    reset_password_request.update(status: 'verified')
    reset_password_request
  end
end
