class AddNewColumnsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :vip, :boolean, default: false
    add_column :users, :role, :string
    add_column :users, :team_member_id, :bigint
    add_index :users, :team_member_id
  end
end