class User < ApplicationRecord
  # Existing associations and validations
  has_many :blogs, foreign_key: :user_id, dependent: :destroy
  has_many :gift_cards, foreign_key: :user_id, dependent: :destroy
  has_many :oauth_access_tokens, foreign_key: :user_id, dependent: :destroy
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
  has_many :active_storage_attachments, foreign_key: 'user_id', dependent: :destroy
  has_many :reacter_reactions,
           class_name: 'Reaction',
           foreign_key: :reacter_id, dependent: :destroy
  has_many :reacted_reactions,
           class_name: 'Reaction',
           foreign_key: :reacted_id, dependent: :destroy

  # New associations based on the updated ERD
  has_many :otp_requests, dependent: :destroy
  enum role: { user: 0, admin: 1, super_admin: 2 }

  # Existing enum
  enum gender: %w[male female other], _suffix: true

  # Existing attachment
  has_one_attached :thumbnail, dependent: :destroy

  # Existing validations
  validates :phone_number, presence: true, uniqueness: true
  validates :failed_attempts, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :confirmation_sent_at, timeliness: { type: :datetime }, allow_nil: true
  validates :unlock_token, presence: true, uniqueness: true, allow_nil: true
  validates :current_sign_in_ip, length: { maximum: 255 }, allow_nil: true
  validates :reset_password_sent_at, timeliness: { type: :datetime }, allow_nil: true
  validates :last_sign_in_ip, length: { maximum: 255 }, allow_nil: true
  validates :sign_in_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :interests, length: { maximum: 500 }, allow_nil: true
  validates :dob, timeliness: { type: :date, on_or_before: -> { Date.current } }, allow_nil: true
  validates :password_confirmation, length: { in: 6..128 }, if: :password_confirmation?
  validates :location, length: { maximum: 255 }, allow_nil: true
  validates :encrypted_password, presence: true
  validates :firstname, length: { maximum: 255 }
  validates :gender, inclusion: { in: genders.keys }
  validates :current_sign_in_at, timeliness: { type: :datetime }, allow_nil: true
  validates :phone_number, length: { maximum: 15 }
  validates :reset_password_token, presence: true, uniqueness: true, allow_nil: true
  validates :unconfirmed_email, length: { maximum: 255 }, allow_nil: true
  validates :confirmed_at, timeliness: { type: :datetime }, allow_nil: true
  validates :lastname, length: { maximum: 255 }
  validates :last_sign_in_at, timeliness: { type: :datetime }, allow_nil: true
  validates :confirmation_token, presence: true, uniqueness: true, allow_nil: true
  validates :locked_at, timeliness: { type: :datetime }, allow_nil: true
  validates :remember_created_at, timeliness: { type: :datetime }, allow_nil: true
  validates :created_at, timeliness: { type: :datetime }, allow_nil: true
  validates :updated_at, timeliness: { type: :datetime }, allow_nil: true
  validates :email, presence: true, uniqueness: true
  validates :vip, inclusion: { in: [true, false] }
  validates :role, inclusion: { in: roles.keys }
  validates :phone_number, length: { in: 0..255 }, if: :phone_number?
  validates :thumbnail, content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif', 'image/svg+xml'],
                        size: { less_than_or_equal_to: 100.megabytes }
  validates :firstname, length: { in: 0..255 }, if: :firstname?
  validates :lastname, length: { in: 0..255 }, if: :lastname?
  validates :dob, timeliness: { type: :date, on_or_before: Date.yesterday }, if: :dob_changed?
  validates :interests, length: { in: 0..0 }, if: :interests?
  validates :location, length: { in: 0..0 }, if: :location?
  validates :email, uniqueness: true, allow_blank: true
  validates :email, length: { in: 0..255 }, if: :email?
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, if: :email_changed?

  # Existing methods
  def reset_failed_attempts!
    self.failed_attempts = 0
    save(validate: false)
  end

  def increment_failed_attempts!
    self.failed_attempts += 1
    self.locked_at = Time.now.utc if failed_attempts >= Devise.maximum_attempts
    save(validate: false)
  end

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

      user.increment_failed_attempts! if user

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