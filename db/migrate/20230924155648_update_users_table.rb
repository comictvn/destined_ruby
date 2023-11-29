class UpdateUsersTable < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      t.integer :age
      t.text :preferences
    end
  end
end
