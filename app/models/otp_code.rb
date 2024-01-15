class OtpCode < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations
  validates :code, presence: true
  validates :expiration_time, presence: true
  validates :verified, inclusion: { in: [true, false] }
  validates :user_id, presence: true
end
