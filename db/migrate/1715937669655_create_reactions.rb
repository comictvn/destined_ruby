class CreateReactions < ActiveRecord::Migration[6.0]
  def change
    create_table :reactions do |t|
      t.references :reacter, null: false, foreign_key: { to_table: :users }
      t.references :reacted, null: false, foreign_key: { to_table: :users }
      t.integer :react_type, null: false

      t.timestamps
    end
  end
end