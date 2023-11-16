class CreateUsersTable < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.json :preferences
      t.references :match, foreign_key: true
      t.timestamps
    end
  end
end
