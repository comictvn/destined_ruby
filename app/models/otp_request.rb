
class OtpRequest < ApplicationRecord
  # Relations
  belongs_to :user

  # Validations
  validates_presence_of :otp_code, :expires_at, :verified, :user_id

  # Scopes
  # Add any scopes if necessary

  # Methods
  def self.create_otp_request(user_id:, phone_number:, otp_code:, expiration_time:)
    create!(
      user_id: user_id,
      otp_code: otp_code,
      expires_at: expiration_time.minutes.from_now,
      verified: false,
      created_at: Time.current,
      updated_at: Time.current
    )
  rescue ActiveRecord::RecordInvalid => e
    # Handle exception, e.g., log error or return a specific message
  end
end
