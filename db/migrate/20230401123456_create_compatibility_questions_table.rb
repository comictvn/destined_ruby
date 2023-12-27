class CreateCompatibilityQuestionsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :compatibility_questions do |t|
      t.text :question

      t.timestamps
    end

    add_reference :user_answers, :compatibility_question, null: false, foreign_key: true
  end
end
