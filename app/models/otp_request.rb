class OtpRequest < ApplicationRecord
  belongs_to :user

  # validations
  validates :otp_code, presence: true, uniqueness: true
  validates :expires_at, presence: true
  validates :verified, inclusion: { in: [true, false] }
  validates :status, presence: true
  validates :user_id, presence: true, numericality: { only_integer: true }

  # callbacks
  before_create :set_expiry, :generate_otp_code, :set_defaults

  # custom methods
  def set_expiry
    self.expires_at ||= 10.minutes.from_now
  end

  def generate_otp_code
    begin
      self.otp_code = SecureRandom.random_number(100000..999999)
    end while self.class.exists?(otp_code: otp_code)
  end

  def set_defaults
    self.verified = false
    self.status = 'pending'
  end

  # You can add custom methods for OtpRequest here
end
