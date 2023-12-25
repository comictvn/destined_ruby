class UserAnswer < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :question

  # Validations
  validates :answer, presence: true
  validates :user_id, presence: true
  validates :question_id, presence: true

  # Custom methods (if any)
end
