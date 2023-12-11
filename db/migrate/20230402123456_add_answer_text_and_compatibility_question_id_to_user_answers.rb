class AddAnswerTextAndCompatibilityQuestionIdToUserAnswers < ActiveRecord::Migration[7.0]
  def change
    # Add new columns to the user_answers table
    add_column :user_answers, :answer_text, :text
    add_column :user_answers, :compatibility_question_id, :bigint

    # Add index for compatibility_question_id column
    add_index :user_answers, :compatibility_question_id

    # Add foreign key for compatibility_question_id column
    add_foreign_key :user_answers, :compatibility_questions, column: :compatibility_question_id
  end
end
