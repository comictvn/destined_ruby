class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :user_profiles do |t|
      t.text :order_history
      t.text :settings
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end