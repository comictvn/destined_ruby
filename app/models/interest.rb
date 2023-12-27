class Interest < ApplicationRecord
  # Associations
  has_many :user_interests, dependent: :destroy

  # Validations
  validates :name, presence: true, length: { maximum: 255 }
end
