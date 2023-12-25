class Question < ApplicationRecord
  # Associations
  has_many :user_answers, dependent: :destroy

  # Validations
  validates :question_text, presence: true, length: { maximum: 255 }

  # Add any custom methods below if necessary
end
