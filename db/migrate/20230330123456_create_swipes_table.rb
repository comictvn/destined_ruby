class CreateSwipesTable < ActiveRecord::Migration[7.0]
  def change
    create_table :swipes do |t|
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.string :direction
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
