class OtpCode < ApplicationRecord
  belongs_to :user
  # validations
  validates :otp_code, presence: true
  validates :is_verified, inclusion: { in: [true, false] }
  validates :user_id, presence: true
end
