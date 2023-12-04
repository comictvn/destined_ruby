class AddContentToUsersTable < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :content, :text
  end
  def down
    remove_column :users, :content
  end
end
