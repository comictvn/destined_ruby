class Question < ApplicationRecord
  # Define the relationship with answers
  has_many :answers, foreign_key: :question_id, dependent: :destroy

  # Validations for Question model
  validates :content, presence: true

  # Add any custom methods below if required
end
