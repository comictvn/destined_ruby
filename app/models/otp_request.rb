class OtpRequest < ApplicationRecord
  # Relations
  belongs_to :user
  has_one :otp_transaction, dependent: :destroy

  # Validations
  validates_presence_of :otp_code, :expires_at, :verified, :user_id

  # Scopes
  # Add any scopes if necessary
end
