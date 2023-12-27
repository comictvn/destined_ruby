class AddCompatibilityQuestionIdToUserAnswers < ActiveRecord::Migration[7.0]
  def change
    add_reference :user_answers, :compatibility_question, null: true, foreign_key: true
  end
end
