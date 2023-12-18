class Question < ApplicationRecord
  # Set the table name if it's not the pluralized form of the model name
  self.table_name = 'questions'

  # Define the relationships
  has_many :answers, dependent: :destroy
  has_many :user_answers, dependent: :destroy

  # Validations
  validates :content, presence: true
  validates :question_text, presence: true

  # Custom methods can be added here
end
