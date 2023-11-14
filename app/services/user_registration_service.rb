class UserRegistrationService < BaseService
  attr_reader :password, :email, :password_confirmation
  def initialize(password, email, password_confirmation)
    @password = password
    @email = email
    @password_confirmation = password_confirmation
  end
  def call
    register
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
  private
  def add_errors(errors)
    errors.each { |error| self.errors.add(error) }
    nil
  end
end
