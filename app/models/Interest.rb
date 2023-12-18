class Interest < ApplicationRecord
  # Define the relationship with user_interests
  has_many :user_interests, dependent: :destroy

  # Validations
  validates :name, presence: true, length: { maximum: 255 }

  # Custom methods can be added here
end
