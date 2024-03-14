class CreateGiftCards < ActiveRecord::Migration[7.0]
  def change
    create_table :gift_cards do |t|
      t.references :user, null: false, foreign_key: true
      t.string :code
      t.timestamps
    end
  end
end
