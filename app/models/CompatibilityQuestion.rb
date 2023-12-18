class CompatibilityQuestion < ApplicationRecord
  # Set table name if it's not the pluralized form of the model name
  self.table_name = 'compatibility_questions'

  # Define relationships
  has_many :user_answers, foreign_key: 'compatibility_question_id', dependent: :destroy

  # Validations
  validates :question_text, presence: true

  # Add any custom methods below
end
