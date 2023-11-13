class User < ApplicationRecord
  # Remove attr_accessor as these are database fields
  # attr_accessor :name, :age, :gender, :location, :preferences, :profile_picture, :bio
  # Add validations
  validates :name, :age, :gender, :location, :preferences, :profile_picture, :bio, presence: true
  validates :age, numericality: { only_integer: true, greater_than: 0 }
  validates :gender, inclusion: { in: %w(male female other) }
  validates :name, length: { maximum: 50 }
  validates :bio, length: { maximum: 500 }
  has_secure_password
  enum gender: { male: 0, female: 1, other: 2 }
  has_many :social_media
  # Method to update user profile
  def update_profile(params)
    self.name = params[:name]
    self.age = params[:age]
    self.gender = params[:gender]
    self.location = params[:location]
    self.preferences = params[:preferences]
    self.profile_picture = params[:profile_picture]
    self.bio = params[:bio]
    save
  end
  # Method to send confirmation message
  def send_confirmation_message
    # Code to send confirmation message goes here
  end
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
