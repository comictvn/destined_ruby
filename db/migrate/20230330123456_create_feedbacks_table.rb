class CreateFeedbacksTable < ActiveRecord::Migration[7.0]
  def change
    create_table :feedbacks do |t|
      t.text :content

      t.timestamps
    end
  end
end
