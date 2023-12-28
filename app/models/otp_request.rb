class OtpRequest < ApplicationRecord
  belongs_to :user

  # validations
  validates :otp_code, presence: true
  validates :expires_at, presence: true
  validates :verified, inclusion: { in: [true, false] }
  validates :status, presence: true
  validates :user_id, presence: true

  # You can add custom methods for OtpRequest here
end
