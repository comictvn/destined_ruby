class AddNewFieldsToUsers < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :failed_attempts, :integer, default: 0, null: false
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unlock_token, :string
    add_column :users, :reset_password_sent_at, :datetime
    add_column :users, :locked_at, :datetime
    add_column :users, :message_id, :bigint
    add_index :users, :unlock_token, unique: true
    add_index :users, :message_id
  end

  def down
    remove_index :users, :unlock_token
    remove_index :users, :message_id
    remove_columns :users, :failed_attempts, :confirmation_sent_at, :unlock_token, :reset_password_sent_at, :locked_at, :message_id
  end
end
