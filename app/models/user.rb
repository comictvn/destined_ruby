class User < ApplicationRecord
  has_secure_password
  has_many :sender_messages,
           class_name: 'Message',
           foreign_key: :sender_id, dependent: :destroy
  has_many :user_chanels, dependent: :destroy
  has_many :matcher1_matchs,
           class_name: 'Match',
           foreign_key: :matcher1_id, dependent: :destroy
  has_many :matcher2_matchs,
           class_name: 'Match',
           foreign_key: :matcher2_id, dependent: :destroy
  has_many :reacter_reactions,
           class_name: 'Reaction',
           foreign_key: :reacter_id, dependent: :destroy
  has_many :reacted_reactions,
           class_name: 'Reaction',
           foreign_key: :reacted_id, dependent: :destroy
  enum gender: %w[male female other], _suffix: true
  has_one_attached :thumbnail, dependent: :destroy
  # validations
  validates :username, presence: { message: "The username is required." }, length: { maximum: 50, message: "You cannot input more 50 characters." }
  validates :password, presence: { message: "The password is required." }, length: { minimum: 8, message: "Password must be at least 8 characters." }
  validates :email, presence: { message: "The email is required." }, uniqueness: true, allow_blank: true
  validates :email, length: { in: 0..255 }, if: :email?
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "Invalid email format." }, if: :email_changed?
  # end for validations
  def generate_reset_password_token
    raw, enc = Devise.token_generator.generate(self.class, :reset_password_token)
    self.reset_password_token   = enc
    self.reset_password_sent_at = Time.now.utc
    save(validate: false)
    raw
  end
  def update_password(new_password)
    self.password = new_password
    save
  end
  class << self
    def authenticate?(email, password)
      user = User.find_for_authentication(email: email)
      return false if user.blank?
      if user&.valid_for_authentication? { user.valid_password?(password) }
        user.reset_failed_attempts!
        return user
      end
      # We will show the error message in TokensController
      return user if user&.access_locked?
      false
    end
    def verify_otp?(phone_number, otp_code)
      phone_number = ::Auths::PhoneNumber.new({ phone_number: phone_number, otp_code: otp_code })
      return unless phone_number.valid?
      ::Auths::PhoneVerification.new(phone_number.formatted_phone_number).verify_otp(otp_code)
      find_by(phone_number: phone_number.formatted_phone_number)
    end
  end
end
