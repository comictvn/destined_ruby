class UserRegistrationService < BaseService
  attr_reader :user_id, :confirmation_code
  def initialize(user_id: nil, confirmation_code: nil)
    @user_id = user_id
    @confirmation_code = confirmation_code
  end
  def call
    if user_id && confirmation_code
      confirm_email(user_id, confirmation_code)
    else
      { error: "Invalid parameters" }
    end
  end
  def confirm_email(user_id, confirmation_code)
    user = User.find_by(id: user_id)
    return { error: "User not found" } unless user
    return { error: "Confirmation code does not match" } unless user.confirmation_code == confirmation_code
    user.update(status: "confirmed")
    { success: "User's email has been confirmed" }
  end
end
