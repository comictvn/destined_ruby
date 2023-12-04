# PATH: /app/services/reset_password_request_service/create.rb
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
end
