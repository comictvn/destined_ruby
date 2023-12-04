class PasswordResetRequest < ApplicationRecord
  belongs_to :user
  # validations
  validates :request_time, presence: true
  validates :status, presence: true
  validates :user_id, presence: true
end
