class Preference < ApplicationRecord
  belongs_to :user, foreign_key: :user_id

  # validations
  validates :preference_data, presence: true
  validates :user_id, presence: true

  # Add any custom methods below if necessary
end
