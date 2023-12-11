class Answer < ApplicationRecord
  # Relationships
  belongs_to :user
  belongs_to :question

  # Validations
  validates :content, presence: true
  validates :user_id, presence: true
  validates :question_id, presence: true

  # Add any custom methods below if required
end
