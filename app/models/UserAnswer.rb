class UserAnswer < ApplicationRecord
  # Set the table name if it's not the pluralized form of the model name
  self.table_name = 'user_answers'

  # Define the relationship with users, questions, and compatibility_questions
  belongs_to :user
  belongs_to :question
  belongs_to :compatibility_question, optional: true

  # Validations
  validates :answer, presence: true
  validates :user_id, presence: true
  validates :question_id, presence: true
  validates :answer_text, presence: true, if: -> { answer.nil? }

  # Custom methods can be added here
end
