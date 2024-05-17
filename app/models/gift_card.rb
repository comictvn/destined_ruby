class GiftCard < ApplicationRecord
  belongs_to :user, foreign_key: 'user_id'

  # Validations
  validates :code, presence: true
  # Add any other necessary validations here
end
