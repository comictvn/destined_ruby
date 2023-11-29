class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, confirmation: true
  validates :password_confirmation, presence: true
  before_create :generate_confirmation_token
  has_many :user_chanels, foreign_key: :user_id
  has_many :matches, foreign_key: :user_id
  def send_confirmation_instructions
    UserMailer.confirmation_email(self).deliver_now
  end
  def confirm_email(user_id, confirmation_code)
    user = User.find_by(id: user_id)
    return "User not found" unless user
    return "Invalid confirmation code" unless user.confirmation_token == confirmation_code
    user.update(status: 'confirmed')
    "Email confirmed successfully"
  end
  private
  def generate_confirmation_token
    self.confirmation_token = SecureRandom.urlsafe_base64
  end
end
