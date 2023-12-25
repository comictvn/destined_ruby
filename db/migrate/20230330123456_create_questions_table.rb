class CreateQuestionsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :questions do |t|
      t.text :question_text

      t.timestamps
    end

    add_index :questions, :question_text
  end
end
