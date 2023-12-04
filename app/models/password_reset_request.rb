class PasswordResetRequest < ApplicationRecord
  belongs_to :user
  # validations
  validates :request_time, presence: true
  validates :status, presence: true
  validates :user_id, presence: true
  def verify
    begin
      update(status: 'verified')
    rescue
      false
    end
  end
end
