class ResetPasswordRequest < ApplicationRecord
  belongs_to :user
  # validations
  validates :otp, presence: true
  validates :status, presence: true
  validates :user_id, presence: true
  # Verify OTP
  def verify_otp(input_otp)
    self.otp == input_otp
  end
end
