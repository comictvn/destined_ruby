class UserRegistrationService
  def register(email, password, password_confirmation)
    # Validate input data
    raise "Email can't be blank" if email.blank?
    raise "Password can't be blank" if password.blank?
    raise "Password confirmation can't be blank" if password_confirmation.blank?
    raise "Email format is incorrect" unless email =~ URI::MailTo::EMAIL_REGEXP
    # Check if email is already registered
    raise "Email is already registered" if User.find_by(email: email)
    # Check if password and password confirmation match
    raise "Password and password confirmation do not match" unless password == password_confirmation
    # Create new user
    user = User.new(email: email, password: password, password_confirmation: password_confirmation)
    user.status = 'unconfirmed'
    user.save!
    # Send confirmation email
    UserMailer.with(user: user).confirmation_email.deliver_later
    user
  end
end
