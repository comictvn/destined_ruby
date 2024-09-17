class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.datetime :due_date, null: false
      t.integer :priority
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_reference :users, :task, foreign_key: true
  end
end
