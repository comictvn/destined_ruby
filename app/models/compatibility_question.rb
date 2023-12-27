class CompatibilityQuestion < ApplicationRecord
  # Associations
  has_many :user_answers, foreign_key: :compatibility_question_id, dependent: :destroy

  # Validations
  validates :question, presence: true
end
