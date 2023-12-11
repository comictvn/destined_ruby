class CreateUserPreferencesTable < ActiveRecord::Migration[7.0]
  def change
    create_table :user_preferences do |t|
      t.json :preference_data
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
