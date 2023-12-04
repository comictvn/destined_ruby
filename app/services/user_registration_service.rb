require 'phonelib'
require 'bcrypt'
class UserRegistrationService
  def register_user(username, email, password)
    raise 'The username is required.' if username.blank?
    raise 'You cannot input more 50 characters.' if username.length > 50
    raise 'The email is required.' if email.blank?
    raise 'Invalid email format.' unless email =~ URI::MailTo::EMAIL_REGEXP
    raise 'Password must be at least 8 characters.' if password.length < 8
    if User.exists?(email: email)
      return { status: 400, message: 'Email already registered' }
    else
      encrypted_password = BCrypt::Password.create(password)
      user = User.create(username: username, email: email, encrypted_password: encrypted_password)
      send_confirmation_email(user)
      return { status: 200, message: 'User was successfully registered.' }
    end
  end
  def send_confirmation_email(user)
    begin
      TwilioGateway.send_email(user.email, 'Confirmation Email', 'Please confirm your email address.')
      return { status: 'success', message: 'Confirmation email sent' }
    rescue => e
      return { status: 'failed', message: e.message }
    end
  end
end
