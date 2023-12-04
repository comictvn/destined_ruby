class OtpCode < ApplicationRecord
  belongs_to :user
  # validations
  validates :otp_code, presence: true
  validates :is_verified, inclusion: { in: [true, false] }
  validates :user_id, presence: true
  # methods
  def self.generate_otp_code(user)
    otp_code = rand(1000..9999)
    create(otp_code: otp_code, is_verified: false, user_id: user.id)
    otp_code
  end
  def self.resend_otp_code(user)
    otp_code = user.otp_codes.last
    if otp_code
      otp_code.update(otp_code: SecureRandom.hex(3), created_at: Time.now)
    end
  end
  def self.resend_otp_code_and_return_info(user)
    otp_code = user.otp_codes.last
    if otp_code
      otp_code.update(otp_code: SecureRandom.hex(3), created_at: Time.now)
      return { otp_code: otp_code.otp_code, user_id: user.id, is_verified: otp_code.is_verified }
    end
  end
end
