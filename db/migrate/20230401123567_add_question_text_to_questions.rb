class AddQuestionTextToQuestions < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :question_text, :text
  end
end
