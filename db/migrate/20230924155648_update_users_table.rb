class UpdateUsersTable < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      t.string :name
      t.text :preferences
      t.references :match, foreign_key: true
    end
  end
end
