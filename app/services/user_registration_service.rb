class UserRegistrationService < BaseService
  attr_reader :user_id, :confirmation_code, :password, :email, :password_confirmation
  def initialize(user_id: nil, confirmation_code: nil, password: nil, email: nil, password_confirmation: nil)
    @user_id = user_id
    @confirmation_code = confirmation_code
    @password = password
    @email = email
    @password_confirmation = password_confirmation
  end
  def call
    if user_id && confirmation_code
      validate_user(user_id, confirmation_code)
    else
      register
    end
  end
  private
  def validate_user(user_id, confirmation_code)
    user = User.find_by(id: user_id)
    return add_errors(["User not found"]) unless user
    return add_errors(["Confirmation code does not match"]) unless user.confirmation_code == confirmation_code
    user.update_status("confirmed")
    user
  end
  def register
    validator = UserValidator.new(password: password, email: email, password_confirmation: password_confirmation)
    return add_errors(validator.errors) unless validator.valid?
    existing_user = User.find_by(email: email)
    return add_errors(["Email is already in use"]) if existing_user
    encrypted_password = BCrypt::Password.create(password)
    user = User.create(password: encrypted_password, email: email)
    return add_errors(user.errors) unless user.persisted?
    UserMailer.send_confirmation_email(email)
    user
  end
  def add_errors(errors)
    errors.each { |error| self.errors.add(error) }
    nil
  end
end
