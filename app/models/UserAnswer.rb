class UserAnswer < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :question
  belongs_to :compatibility_question # Added new association

  # Validations
  validates :answer, presence: true
  validates :user_id, presence: true
  validates :question_id, presence: true
  validates :compatibility_question_id, presence: true # Added new validation

  # Custom methods (if any)
end
