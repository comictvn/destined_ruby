class OtpTransaction < ApplicationRecord
  # Associations
  belongs_to :otp_request

  # Validations
  validates :transaction_id, presence: true
  validates :status, presence: true
  validates :otp_request_id, presence: true
end
