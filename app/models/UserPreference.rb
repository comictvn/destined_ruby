class UserPreference < ApplicationRecord
  # Set the table name if it's not the pluralized form of the model name
  self.table_name = 'user_preferences'

  # Define the relationship with the User model
  belongs_to :user

  # Validations
  validates :preference_data, presence: true
  validates :user_id, presence: true

  # Custom methods can be added here
end
