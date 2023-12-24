class CreateTasksTable < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.timestamps
      t.string :title
      t.text :description
      t.datetime :due_date
      t.string :status
      t.references :user, null: false, foreign_key: true
    end
  end
end
