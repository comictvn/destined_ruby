
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Existing associations
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

  # New associations based on the updated ERD
  has_many :otp_requests, dependent: :destroy

  # Existing enum
  enum gender: %w[male female other], _suffix: true

  # New validations based on business logic
  validates :firstname, presence: true, length: { maximum: 50 }
  validates :lastname, presence: true, length: { maximum: 50 }
  validates :gender, inclusion: { in: genders.keys }
  validates :dob, presence: true

  # Existing attachment
  has_one_attached :thumbnail, dependent: :destroy

  # Existing validations
  validates :phone_number, presence: true, uniqueness: true
  validates :phone_number, length: { in: 0..255 }, if: :phone_number?
  validates :thumbnail, content_type: ['image/png', 'image/jpg', 'image/jpeg'],
                        size: { less_than_or_equal_to: 5.megabytes }
  validates :interests, length: { in: 0..0 }, if: :interests?
  validates :location, length: { in: 0..0 }, if: :location?
  validates :email, uniqueness: { message: I18n.t('validation.errors.email_uniqueness') }, allow_blank: true
  validates :email, length: { in: 0..255 }, if: :email?
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, if: :email_changed?

  # Existing methods
  def generate_reset_password_token
    raw, enc = Devise.token_generator.generate(self.class, :reset_password_token)
    self.reset_password_token   = enc
    self.reset_password_sent_at = Time.now.utc
    save(validate: false)
    raw
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
