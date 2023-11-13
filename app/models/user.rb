class User < ApplicationRecord
  has_secure_password
  enum gender: { male: 0, female: 1, other: 2 }
  has_many :social_media
  def self.authenticate?(email, password)
    user = User.find_by(email: email)
    return user if user && user.authenticate(password)
    nil
  end
  def generate_reset_password_token
    SecureRandom.urlsafe_base64
  end
  def self.forgot_password(email)
    user = User.find_by(email: email)
    return 'Email does not exist' unless user
    user.generate_reset_password_token
    # Here you should add the code to send the reset password token to the user's email.
    # This depends on the mailer system you are using in your application.
    'Reset password token has been sent to your email'
  end
  def self.login(email, password)
    user = User.authenticate?(email, password)
    if user
      session_token = user.generate_reset_password_token
      { user: user, session_token: session_token, message: 'Login successful' }
    else
      { message: 'Invalid email or password' }
    end
  end
end
