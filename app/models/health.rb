class Health < ApplicationRecord
  # Add your associations, validations, and methods here following the structure and conventions in the User model example.
  validates :status, presence: true
end
