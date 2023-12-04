class UpdateUsersTable < ActiveRecord::Migration[6.0]
  def change
    change_table :users do |t|
      t.string :name
      t.string :phone
      t.boolean :is_verified, default: false
    end
  end
end
