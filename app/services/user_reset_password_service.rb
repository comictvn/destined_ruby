class UserResetPasswordService
  def create_reset_password_request(user_id, otp)
    user = User.find_by(id: user_id)
    return 'User does not exist' unless user
    reset_password_request = ResetPasswordRequestService::Create.new(user_id: user_id, otp: otp, status: 'pending').execute
    reset_password_request.status
  end
end
