class UserAnswer < ApplicationRecord
  # Set the table name if it's not the pluralized form of the model name
  self.table_name = 'user_answers'

  # Define the relationship with users and questions
  belongs_to :user
  belongs_to :question

  # Validations
  validates :answer, presence: true
  validates :user_id, presence: true
  validates :question_id, presence: true

  # Custom methods can be added here
end
