class CreateMatchFeedbacksTable < ActiveRecord::Migration[7.0]
  def change
    create_table :match_feedbacks do |t|
      t.text :feedback_text

      t.timestamps
    end
  end
end
