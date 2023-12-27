class UserInterest < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :interest

  # Validations
  validates :user_id, presence: true
  validates :interest_id, presence: true
end
