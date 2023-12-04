require 'phonelib'
require 'bcrypt'
class UserRegistrationService
  def register_user(email, password, password_confirmation)
    raise 'The email is required.' if email.blank?
    raise 'Invalid email format.' unless email =~ URI::MailTo::EMAIL_REGEXP
    raise 'Password must be at least 8 characters.' if password.length < 8
    raise 'Password and password confirmation do not match.' if password != password_confirmation
    if User.exists?(email: email)
      return { status: 'failed', message: 'Email already registered' }
    else
      encrypted_password = BCrypt::Password.create(password)
      user = User.create(email: email, encrypted_password: encrypted_password)
      send_confirmation_email(user)
      return { status: 'success', message: 'Registration successful', user: user }
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
