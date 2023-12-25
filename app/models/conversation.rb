class Conversation < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :messages, dependent: :destroy

  # Validations
  validates :user_id, presence: true

  # Add any custom methods below if necessary
end
