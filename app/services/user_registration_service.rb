class UserRegistrationService
  def initialize(email, password, password_confirmation)
    @email = email
    @password = password
    @password_confirmation = password_confirmation
  end
  def register
    validate_input
    check_email
    user = create_user
    send_confirmation_email(user)
    user.id
  end
  private
  def validate_input
    validator = UserValidator.new(@email, @password, @password_confirmation)
    errors = validator.validate
    raise CustomException.new(errors) unless errors.empty?
  end
  def check_email
    user = User.find_by(email: @email)
    raise CustomException.new("Email is already in use") if user
  end
  def create_user
    encrypted_password = Devise::Encryptor.digest(User, @password)
    User.create!(email: @email, encrypted_password: encrypted_password)
  end
  def send_confirmation_email(user)
    UserMailer.confirmation_email(user).deliver_now
  end
end
