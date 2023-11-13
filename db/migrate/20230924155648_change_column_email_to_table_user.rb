class ChangeColumnEmailToTableUser < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :email, :string
    add_column :users, :email, :string, null: true
  end
end
