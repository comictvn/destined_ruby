class User < ApplicationRecord
  has_secure_password
  has_many :user_chanels, dependent: :destroy
  has_many :reset_password_requests, dependent: :destroy
  has_many :otp_codes, dependent: :destroy
  has_many :messages, dependent: :destroy
  # validations
  validates :phone_number, presence: true, uniqueness: true
  validates :phone_number, length: { in: 0..255 }, if: :phone_number?
  validates :firstname, length: { in: 0..255 }, if: :firstname?
  validates :lastname, length: { in: 0..255 }, if: :lastname?
  validates :dob, timeliness: { type: :date, on_or_before: Date.yesterday }, if: :dob_changed?
  validates :interests, length: { in: 0..0 }, if: :interests?
  validates :location, length: { in: 0..0 }, if: :location?
  validates :email, uniqueness: true, allow_blank: true
  validates :email, length: { in: 0..255 }, if: :email?
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, if: :email_changed?
  validates :content, length: { maximum: 255 }, if: :content?
  validates :name, presence: true
  validates :phone, presence: true, phone: { possible: true, allow_blank: false }
  validates :password, length: { minimum: 8 }, if: :password
  before_save :hash_password
  # methods
  def self.register_phone_number(phone_number)
    user = User.new(phone_number: phone_number, is_verified: false)
    user.save
    user
  end
  def update_password(new_password)
    self.password = new_password
    save
  end
  def self.update_password_by_id(id, new_password)
    user = User.find_by(id: id)
    return { status: false, message: 'User does not exist' } unless user
    user.update_password(new_password)
    { status: true, message: 'Password updated successfully' }
  end
  def generate_reset_password_token
    raw, enc = Devise.token_generator.generate(self.class, :reset_password_token)
    self.reset_password_token   = enc
    self.reset_password_sent_at = Time.now.utc
    save(validate: false)
    raw
  end
  def generate_otp_code
    otp_code = rand(1000..9999)
    self.otp_codes.create(otp_code: otp_code, is_verified: false)
    otp_code
  end
  def resend_otp_code
    otp_code = self.otp_codes.last
    if otp_code
      otp_code.update(otp_code: SecureRandom.hex(3), created_at: Time.now)
    end
  end
  def resend_otp_code_and_return_info
    otp_code = self.otp_codes.last
    if otp_code
      otp_code.update(otp_code: SecureRandom.hex(3), created_at: Time.now)
      return { otp_code: otp_code.otp_code, user_id: self.id, is_verified: self.is_verified }
    end
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
  private
  def hash_password
    self.password = BCrypt::Password.create(self.password)
  end
end
